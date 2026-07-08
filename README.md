# Spree Starter

A Rails application pre-configured with [Spree Commerce](https://spreecommerce.org). Use it as a starting point for your own store, as the backend for a headless storefront, or as the basis for customization.

## Quick Start

If you want a full project scaffold (this backend + a Next.js storefront + the `spree` CLI), use [`create-spree-app`](https://github.com/spree/spree/tree/main/packages/create-spree-app):

```bash
npx create-spree-app my-store
```

If you want **just this backend** (e.g. to fork and customize it on its own), clone it directly and follow the development setup below.

## Development

Development is Docker-based: the only thing you need on your host is Docker (Docker Desktop, OrbStack, or any compatible runtime). No Ruby, no Postgres, no Redis on the host.

```bash
git clone https://github.com/spree/spree-starter.git my-store
cd my-store
cp .env.example .env
# Edit .env and set SECRET_KEY_BASE — generate one with:
#   docker run --rm ruby:slim ruby -e 'require "securerandom"; puts SecureRandom.hex(64)'

docker compose -f docker-compose.dev.yml up -d
docker compose -f docker-compose.dev.yml exec web bin/rails db:prepare db:seed
```

The app is now running at [http://localhost:3000](http://localhost:3000):

- **Admin:** [http://localhost:3000/admin](http://localhost:3000/admin) — seeded admin credentials are printed by `db:seed`
- **Store API:** [http://localhost:3000/api/v3/store/products](http://localhost:3000/api/v3/store/products)
- **Sidekiq:** [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq)
- **Health:** [http://localhost:3000/up](http://localhost:3000/up)
- **PostgreSQL (host):** `localhost:5433` (user: `postgres`, db: `spree_development`) — connect with TablePlus, DataGrip, or `psql`. Bound to `127.0.0.1` only; override the port with `SPREE_DB_PORT` when running several projects side by side.

### How development works

The dev compose (`docker-compose.dev.yml`) is set up so editing local files takes effect immediately, with no rebuild loop:

| What changed | What you do | Rebuild image? |
|---|---|---|
| Any `.rb`, `.erb`, `.yml`, `.tailwind.css` under `app/`, `config/`, `lib/` | Just save the file — Zeitwerk reloads on next request | No |
| Add or update a gem | `docker compose -f docker-compose.dev.yml exec web bundle add <gem>` (or `bundle update <gem>`) — gems persist in a named volume | No |
| `db/migrate/*` | `docker compose -f docker-compose.dev.yml exec web bin/rails db:migrate` | No |
| `.ruby-version` or `Dockerfile` changed | `docker compose -f docker-compose.dev.yml down -v` (wipes volumes so the new image's gem baseline gets re-seeded), then `up --build` | Yes |

Source is bind-mounted into the container (`./:/rails`), gems live in a Docker-managed `bundle_cache` volume, ActiveStorage uploads live in `storage_data`. The dev image is built from the `dev` target in the Dockerfile — it has `build-essential` and dev/test gems pre-installed so native-extension gems work out of the box.

### Common commands

```bash
# Compose alias (set once)
alias dc='docker compose -f docker-compose.dev.yml'

# Run any Rails command
dc exec web bin/rails console
dc exec web bin/rails db:migrate
dc exec web bin/rails routes

# Run Spree generators
dc exec web bin/rails g spree:model Brand name:string slug:string

# Run rake tasks (data backfills, search reindex, etc.)
dc exec web bin/rake spree:search:reindex

# Tail logs
dc logs -f web

# Stop everything
dc down
```

If this is verbose, install the [`@spree/cli`](https://www.npmjs.com/package/@spree/cli) which wraps these as `spree exec`, `spree rails`, `spree generate`, `spree migrate`, etc.

### Running tests

Tests run inside the web container against a dedicated `spree_test` database — your development data is never touched. Create the test database once, then run RSpec:

```bash
dc exec web bin/rails db:test:prepare        # one-time test database setup
dc exec -e RAILS_ENV=test web bundle exec rspec
dc exec -e RAILS_ENV=test web bundle exec rspec spec/models/my_model_spec.rb:15
```

With the [`@spree/cli`](https://www.npmjs.com/package/@spree/cli) this is `spree rails db:test:prepare` and `spree rspec` (which sets `RAILS_ENV=test` for you):

```bash
spree rspec                                  # full suite
spree rspec spec/models/my_model_spec.rb:15  # one example
spree rspec --format documentation
```

### Environment variables

`docker-compose.dev.yml` sets sensible dev defaults for `DATABASE_HOST`, `REDIS_URL`, and `MEILISEARCH_URL`, while `RAILS_ENV` is baked into the Dockerfile `dev` stage. (It deliberately avoids `DATABASE_URL`, which would override `database.yml` for every Rails env and point the test suite at the development database.) Most of `.env.example` is production-shaped and ignored in dev. The only variable you must set is:

| Variable | Required | Notes |
|---|---|---|
| `SECRET_KEY_BASE` | Yes | Generate any 64-byte hex string. Stable across restarts so cookies/sessions survive. |
| `SPREE_PORT` | No | Host port for the web service (default `3000`) |
| `SPREE_DB_PORT` | No | Host port for Postgres (default `5433`, bound to `127.0.0.1`) |
| `SPREE_MEILISEARCH_PORT` | No | Host port for Meilisearch (default `7700`, bound to `127.0.0.1`) |
| `MAILPIT_UI_PORT` | No | Host port for the Mailpit web UI (default `8025`, bound to `127.0.0.1`) |
| `MAILPIT_SMTP_PORT` | No | Host port for Mailpit's SMTP endpoint (default `1025`, bound to `127.0.0.1`) |
| `SIDEKIQ_DB_POOL` | No | Worker thread pool size (default `27`) |

Postgres and Meilisearch run passwordless in dev, so their host ports bind to loopback only — set the `SPREE_*_PORT` variables to run multiple projects side by side instead of exposing them beyond `localhost`.

For production deployments (S3, SMTP, Sentry, etc.) see [the environment variables docs](https://docs.spreecommerce.org/developer/deployment/environment_variables).

### Emails in development

All outgoing mail is captured by [Mailpit](https://mailpit.axllent.org/) — nothing is ever delivered externally. Open **http://localhost:8025** to read every email the app sends (order confirmations, password resets, invitations, …). No configuration needed; it works out of the box with both compose files.

To deliver through a real SMTP provider instead, set `SMTP_HOST` (and `SMTP_USERNAME`/`SMTP_PASSWORD`/`SMTP_PORT`) in `.env` — those take precedence over the Mailpit default.

## Customization

This is a standard Spree application. Customize it however you need — see the [Spree Customization Guide](https://docs.spreecommerce.org/developer/customization).

## Native Ruby (advanced)

If you prefer the fastest possible inner loop and are happy installing Ruby, Postgres, and Redis on your host, you can skip Docker entirely.

**Prerequisites:** Ruby (see `.ruby-version`), PostgreSQL, Redis. `bin/setup` installs Ruby via [mise](https://mise.jdx.dev) if available, otherwise points you at `brew bundle` (from the included `Brewfile`).

```bash
bin/setup    # installs deps, prepares the database, runs db:seed
bin/dev      # starts web + worker + Tailwind watcher via Foreman
```

Then visit [http://localhost:3000](http://localhost:3000). Default admin credentials are printed by `db:seed`.

## Deployment

For self-hosted Docker deployment, one-click Render deploys, and managed-host guides, see [the deployment docs](https://docs.spreecommerce.org/developer/deployment).

## License

[MIT](LICENSE.md)
