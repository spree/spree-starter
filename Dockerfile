# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=4.0.1
ARG NODE_VERSION=22
# CLI release line the stock dashboard template is extracted from (only used
# when the build context has no apps/dashboard). Caret-pinned so template
# fixes in CLI minors/patches reach image rebuilds automatically while a
# future CLI major (which may reshape the template layout) requires a
# deliberate bump here.
ARG SPREE_CLI_VERSION=^2.4.0

# Layout normalization — the same Dockerfile builds from either context shape,
# detected from the files actually present (no build args, no named contexts,
# so it behaves identically under plain `docker build`, Render, Railway, and
# `spree build --production`):
#
#   create-spree-app project:
#     context = repo root; Rails app in backend/, React Dashboard in
#     apps/dashboard/.
#
#   standalone:
#     context = Rails app root, no backend/ or apps/.
#
# backend/Gemfile marks the project layout; apps/dashboard/ marks a custom
# dashboard (without it, the stock template bundled with @spree/cli is baked).
FROM docker.io/library/alpine:3.21 AS ctx
COPY . /ctx
RUN mkdir -p /rails-src /dashboard-src && \
  if [ -f /ctx/backend/Gemfile ]; then \
    cp -R /ctx/backend/. /rails-src/; \
  else \
    cp -R /ctx/. /rails-src/; \
  fi && \
  if [ -f /ctx/apps/dashboard/package.json ]; then \
    cp -R /ctx/apps/dashboard/. /dashboard-src/ && \
    rm -rf /dashboard-src/node_modules /dashboard-src/dist /dashboard-src/.tanstack && \
    touch /dashboard-src/.spree-custom-dashboard; \
  fi

# Builds the React Dashboard served by Rails at /dashboard (single-node
# topology: same origin as the Admin API, so no CORS or cookie
# configuration). Your apps/dashboard when the context has one, the stock
# template otherwise. Only dist/ reaches the final image; the Node toolchain
# never does.
FROM docker.io/library/node:$NODE_VERSION-slim AS dashboard
ARG SPREE_CLI_VERSION

WORKDIR /dashboard
COPY --from=ctx /dashboard-src /dashboard
# Custom apps install their committed lockfile verbatim (--frozen-lockfile:
# drift between package.json and the lockfile fails loudly instead of
# silently re-resolving inside the image). The stock template ships no
# lockfile, so it resolves fresh.
RUN corepack enable pnpm && \
  if [ -f .spree-custom-dashboard ]; then \
    pnpm install --frozen-lockfile; \
  else \
    npm pack "@spree/cli@${SPREE_CLI_VERSION}" --pack-destination /tmp && \
    tar -xzf /tmp/spree-cli-*.tgz -C /tmp && \
    cp -r /tmp/package/dist/templates/dashboard-starter/. . && \
    pnpm install; \
  fi && \
  VITE_BASE_PATH=/dashboard/ pnpm build

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips postgresql-client && \
  ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
  BUNDLE_DEPLOYMENT="1" \
  BUNDLE_PATH="/usr/local/bundle" \
  BUNDLE_WITHOUT="development:test" \
  LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config zlib1g-dev && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY --from=ctx /rails-src/.ruby-version /rails-src/Gemfile /rails-src/Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

# Copy application code
COPY --from=ctx /rails-src ./

# Precompile bootsnap code for faster boot times and assets
RUN bundle exec bootsnap precompile app/ lib/ && \
  SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Development stage: inherits the build stage (which has build-essential,
# libpq-dev, etc. and a full bundle minus dev/test). Adds the dev/test gems
# on top so native-extension gems compile against the build tooling that's
# already present. Targeted by docker-compose.dev.yml via `target: dev`.
FROM build AS dev

ENV RAILS_ENV="development" \
  BUNDLE_DEPLOYMENT="0" \
  BUNDLE_WITHOUT=""

# Install dev/test gems on top of the production bundle from the build stage.
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Match the production image's user setup so file ownership (bind-mount,
# bundle volume) is consistent across dev and prod.
RUN groupadd --system --gid 1000 rails && \
  useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
  chown -R rails:rails "${BUNDLE_PATH}" /rails
USER 1000:1000

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]

# Final stage for app image (production)
FROM base

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
  useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
USER 1000:1000

# Copy built artifacts: gems, application
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# React Dashboard, served by Rails at /dashboard (see the dashboard stage
# above). The bundle is origin-relative — it works on any host.
COPY --chown=rails:rails --from=dashboard /dashboard/dist /rails/dashboard
ENV SPREE_DASHBOARD_DIST_PATH="/rails/dashboard"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
