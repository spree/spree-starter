# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=4.0.9
ARG NODE_VERSION=22
# CLI release line the stock dashboard and seller-panel templates are
# extracted from (only used when the build context has no apps/dashboard or
# apps/seller-dashboard). Caret-pinned so template fixes in CLI minors/patches
# reach image rebuilds automatically while a future CLI major (which may
# reshape the template layout) requires a deliberate bump here.
#
# The floor matters: templates/seller-dashboard-starter first ships in the
# 3.0 line (which also drops the legacy Rails admin), so an older CLI has no
# stock seller panel to bake and the seller stage fails rather than silently
# producing an empty bundle.
ARG SPREE_CLI_VERSION=^3.0.0

# Layout normalization — the same Dockerfile builds from either context shape,
# detected from the files actually present (no build args, no named contexts,
# so it behaves identically under plain `docker build`, Render, Railway, and
# `spree build --production`):
#
#   create-spree-app project:
#     context = repo root; Rails app in server/ (backend/ in projects
#     scaffolded before the rename), React Dashboard in apps/dashboard/.
#
#   standalone:
#     context = Rails app root, no server/, backend/ or apps/.
#
# server/Gemfile (or backend/Gemfile) marks the project layout; apps/dashboard/ and
# apps/seller-dashboard/ mark customized apps (without them, the stock
# templates bundled with @spree/cli are baked).
FROM docker.io/library/alpine:3.21 AS ctx
COPY . /ctx
RUN mkdir -p /rails-src /dashboard-src /seller-dashboard-src && \
  if [ -f /ctx/server/Gemfile ]; then \
    cp -R /ctx/server/. /rails-src/; \
  elif [ -f /ctx/backend/Gemfile ]; then \
    cp -R /ctx/backend/. /rails-src/; \
  else \
    cp -R /ctx/. /rails-src/; \
  fi && \
  if [ -f /ctx/apps/dashboard/package.json ]; then \
    cp -R /ctx/apps/dashboard/. /dashboard-src/ && \
    rm -rf /dashboard-src/node_modules /dashboard-src/dist /dashboard-src/.tanstack && \
    touch /dashboard-src/.spree-custom-app; \
  fi && \
  if [ -f /ctx/apps/seller-dashboard/package.json ]; then \
    cp -R /ctx/apps/seller-dashboard/. /seller-dashboard-src/ && \
    rm -rf /seller-dashboard-src/node_modules /seller-dashboard-src/dist /seller-dashboard-src/.tanstack && \
    touch /seller-dashboard-src/.spree-custom-app; \
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
  if [ -f .spree-custom-app ]; then \
    pnpm install --frozen-lockfile; \
  else \
    npm pack "@spree/cli@${SPREE_CLI_VERSION}" --pack-destination /tmp && \
    tar -xzf /tmp/spree-cli-*.tgz -C /tmp && \
    if [ ! -d /tmp/package/dist/templates/dashboard-starter ]; then \
      echo "@spree/cli@${SPREE_CLI_VERSION} ships no dashboard template — raise SPREE_CLI_VERSION." >&2; \
      exit 1; \
    fi && \
    cp -r /tmp/package/dist/templates/dashboard-starter/. . && \
    pnpm install; \
  fi && \
  VITE_BASE_PATH=/dashboard/ pnpm build

# Builds the marketplace Seller Panel served by Rails at /sellers. Same
# topology and same two context shapes as the dashboard stage above. It is
# always built: a store that runs no marketplace simply never links to
# /sellers, and keeping the stages symmetrical means a marketplace never
# discovers at deploy time that its panel was left out of the image.
FROM docker.io/library/node:$NODE_VERSION-slim AS seller-dashboard
ARG SPREE_CLI_VERSION

WORKDIR /seller-dashboard
COPY --from=ctx /seller-dashboard-src /seller-dashboard
RUN corepack enable pnpm && \
  if [ -f .spree-custom-app ]; then \
    pnpm install --frozen-lockfile; \
  else \
    npm pack "@spree/cli@${SPREE_CLI_VERSION}" --pack-destination /tmp && \
    tar -xzf /tmp/spree-cli-*.tgz -C /tmp && \
    if [ ! -d /tmp/package/dist/templates/seller-dashboard-starter ]; then \
      echo "@spree/cli@${SPREE_CLI_VERSION} ships no seller-panel template — raise SPREE_CLI_VERSION." >&2; \
      exit 1; \
    fi && \
    cp -r /tmp/package/dist/templates/seller-dashboard-starter/. . && \
    pnpm install; \
  fi && \
  VITE_BASE_PATH=/sellers/ pnpm build

FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Install base packages. No postgresql-client: the pg gem vendors its own
# libpq, and Debian's postgresql-client drags in ~70MB of perl/gnupg
# dependencies. The dev stage adds it back for psql convenience.
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y curl libjemalloc2 libvips && \
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

# psql for debugging against the compose postgres (production doesn't need it).
RUN apt-get update -qq && \
  apt-get install --no-install-recommends -y postgresql-client && \
  rm -rf /var/lib/apt/lists /var/cache/apt/archives

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

# Copy built artifacts: gems, application.
COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --chown=rails:rails --from=build /rails /rails

# React Dashboard, served by Rails at /dashboard (see the dashboard stage
# above). The bundle is origin-relative — it works on any host.
COPY --chown=rails:rails --from=dashboard /dashboard/dist /rails/dashboard
ENV SPREE_DASHBOARD_DIST_PATH="/rails/dashboard"

# Marketplace Seller Panel, served by Rails at /sellers (see the
# seller-dashboard stage above). Origin-relative, like the dashboard.
COPY --chown=rails:rails --from=seller-dashboard /seller-dashboard/dist /rails/seller-dashboard
ENV SPREE_SELLER_PANEL_DIST_PATH="/rails/seller-dashboard"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
