# syntax=docker/dockerfile:1
# check=error=true

ARG RUBY_VERSION=4.0.1
ARG NODE_VERSION=22
# Which React Dashboard the image bakes (served by Rails at /dashboard —
# the single-node topology: same origin as the Admin API, so no CORS or
# cookie configuration). Only dist/ reaches the final image; the Node
# toolchain never does.
#
#   stock  (default) — the template published inside @spree/cli, with
#                      dependency pins matching that CLI release
#   custom           — your own dashboard app, provided as a named build
#                      context (`spree build --production` does this):
#
#     docker build backend/ \
#       --build-arg DASHBOARD_SOURCE=custom \
#       --build-context dashboard-src=./apps/dashboard
ARG DASHBOARD_SOURCE=stock

FROM docker.io/library/node:$NODE_VERSION-slim AS dashboard-stock

WORKDIR /dashboard
RUN npm pack @spree/cli --pack-destination /tmp && \
  tar -xzf /tmp/spree-cli-*.tgz -C /tmp && \
  cp -r /tmp/package/dist/templates/dashboard-starter/. . && \
  corepack enable pnpm && \
  pnpm install && \
  VITE_BASE_PATH=/dashboard/ pnpm build

FROM docker.io/library/node:$NODE_VERSION-slim AS dashboard-custom

WORKDIR /dashboard
COPY --from=dashboard-src . .
# Defensive: host node_modules/build output must never leak into the image
# build (wrong platform, stale artifacts).
RUN rm -rf node_modules dist .tanstack && \
  corepack enable pnpm && \
  pnpm install && \
  VITE_BASE_PATH=/dashboard/ pnpm build

# BuildKit resolves stages lazily: with the default `stock`, the custom
# stage (and its dashboard-src context) is never evaluated, so plain
# `docker build backend/` needs no extra flags.
FROM dashboard-${DASHBOARD_SOURCE} AS dashboard

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
COPY .ruby-version Gemfile Gemfile.lock ./
RUN bundle install && \
  rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
  bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

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

# Stock React Dashboard, served by Rails at /dashboard (see the dashboard
# stage above). The bundle is origin-relative — it works on any host.
COPY --chown=rails:rails --from=dashboard /dashboard/dist /rails/dashboard
ENV SPREE_DASHBOARD_DIST_PATH="/rails/dashboard"

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
