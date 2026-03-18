# Spree Starter

A Rails application pre-configured with [Spree Commerce](https://spreecommerce.org). Use it as a starting point for your own store, or as the backend for a headless storefront.

## Quick Start

The fastest way to get started is with [create-spree-app](https://github.com/spree/spree/packages/create-spree-app):

```bash
npx create-spree-app my-store
```

This scaffolds a full project with Docker, a Next.js storefront, and this backend — all configured and ready to run.

## Manual Setup

### Prerequisites

- Ruby (see `.ruby-version`)
- PostgreSQL
- Redis

### Install & Run

`bin/setup` will use [Mise](https://mise.jdx.dev/) to install all dependencies.

```bash
bin/setup
bin/dev
```

The app starts at [http://localhost:3000](http://localhost:3000).

- **Admin:** [http://localhost:3000/admin](http://localhost:3000/admin)
- **API:** [http://localhost:3000/api/v3/store/products](http://localhost:3000/api/v3/store/products)
- **Health check:** [http://localhost:3000/up](http://localhost:3000/up)

Default admin credentials are created during `db:seed`.

## Docker

Build and run with Docker:

```bash
docker build -t my-spree .
docker run -p 3000:3000 \
  -e DATABASE_URL=postgres://user:pass@host:5432/spree \
  -e REDIS_URL=redis://localhost:6379/0 \
  -e SECRET_KEY_BASE=$(bin/rails secret) \
  my-spree
```

See [Docker deployment docs](https://docs.spreecommerce.org/developer/deployment/docker) for a full `docker-compose.yml` example.

## Environment Variables

Copy `.env.example` to `.env` and configure:

| Variable | Required | Description |
|---|---|---|
| `DATABASE_URL` | Yes (production) | PostgreSQL connection URL |
| `REDIS_URL` | Yes (production) | Redis URL for jobs, caching, and Action Cable |
| `SECRET_KEY_BASE` | Yes (production) | Generate with `bin/rails secret` |
| `PORT` | No | Web server port (default: 3000) |

See [Environment Variables docs](https://docs.spreecommerce.org/developer/deployment/environment_variables) for the full list (SMTP, S3, Sentry, SSL, etc.).

## Customization

This is a standard Rails application. Customize it however you need:

- **Add gems** to `Gemfile`
- **Override models** with decorators in `app/models/`
- **Add controllers** in `app/controllers/`
- **Configure Spree** in `config/initializers/spree.rb`
- **Add migrations** with `bin/rails generate migration`

See the [Spree Customization Guide](https://docs.spreecommerce.org/developer/customization) for details.

## Spree Core Development

To develop against a local checkout of the Spree gems:

```bash
# Set SPREE_PATH to your local spree monorepo
echo 'SPREE_PATH=../spree' > .env
bundle install
bin/dev
```

The `Gemfile` automatically uses local gems when `SPREE_PATH` is set.

## License

[MIT](LICENSE.md)
