# Spree Starter

The Rails application behind every [Spree Commerce](https://spreecommerce.org) 6 project. It serves:

- the **Store API** for storefronts and mobile apps
- the **Admin API**
- the **Admin Dashboard**, at `/dashboard`
- **background jobs**, with their dashboard at `/jobs`
- **transactional emails**

Projects created with `create-spree-app` keep this application in their `server/` directory.

## Getting started

Create a new project with [`create-spree-app`](https://spreecommerce.org/docs/developer/create-spree-app/quickstart):

```bash
npx create-spree-app@latest my-store
```

It sets up this application together with:

- the Admin Dashboard and an optional Seller Panel for marketplaces, as apps you can customize
- an optional Next.js storefront
- the [Spree CLI](https://spreecommerce.org/docs/developer/cli/quickstart), which runs everything in Docker
- the Spree agent skills for AI coding agents

You only need Node.js and Docker.

Just evaluating Spree? Skip self-hosting and use a [hosted sandbox](https://spreecommerce.org).

## Customization

Start with the [Customization Guide](https://spreecommerce.org/docs/developer/customization/quickstart). It covers, in the order you should reach for them:

- events and subscribers
- workflow hooks
- dependencies
- extensions
- decorators, as a last resort

Run commands through the Spree CLI, never through `bin/rails` or `bundle` directly. For example, `spree generate subscriber`, `spree migrate` and `spree rspec`.

## Coding agents

[`AGENTS.md`](AGENTS.md) holds the instructions for coding agents such as Claude Code, Codex, Cursor and Copilot. `CLAUDE.md` imports it.

For deeper Spree knowledge, install the [Spree agent skills](https://spreecommerce.org/docs/developer/agentic/agent-skills):

```bash
npx skills add spree/agent-skills
```

## Environment variables

[`.env.example`](.env.example) lists the required variables. See the [Environment Variables reference](https://spreecommerce.org/docs/developer/deployment/environment_variables) for the full list.

## Deployment

This application builds into a single Docker image: the API, the Admin Dashboard and background jobs. [`render.yaml`](render.yaml) deploys it to Render.

See the [Deployment Guide](https://spreecommerce.org/docs/developer/deployment/quickstart) for Render, AWS and other Docker hosts.

## Docker image

Every release of this repository is published as [`ghcr.io/spree/spree`](https://github.com/orgs/spree/packages/container/package/spree), tagged with the Spree version and `latest`, for `linux/amd64` and `linux/arm64`. It is built from this repository's [`Dockerfile`](Dockerfile) by [`.github/workflows/release.yml`](.github/workflows/release.yml).

The image holds this application with the Store and Admin APIs, the MCP server, the Admin Dashboard and Seller Panel, and background jobs. It needs Postgres; [`docker-compose.yml`](docker-compose.yml) runs it with Postgres and Mailpit:

```bash
cp .env.example .env   # then set SECRET_KEY_BASE, e.g. to the output of: openssl rand -hex 64
docker compose up
```

The API then listens on <http://localhost:3000> and the Admin Dashboard on <http://localhost:3000/dashboard>. You don't need Ruby to run the image or to integrate with it through the APIs and TypeScript SDKs — only to customize the backend.

## License

[MIT](LICENSE.md)
