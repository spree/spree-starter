# Spree Commerce API

Instructions for coding agents working on this Rails application, powered by [Spree Commerce](https://spreecommerce.org) 6. `CLAUDE.md` only imports this file — edit this one.

In a project created with `create-spree-app` this app lives in `server/`, and the project root (the directory above it) has its own `AGENTS.md` covering the whole project.

## Run everything through the Spree CLI

The API, its database and its background jobs run in Docker containers managed by the [Spree CLI](https://spreecommerce.org/docs/developer/cli/quickstart) (`@spree/cli`). The CLI is the only supported way to run commands against this app.

- **Where to run it:** from the project root, through the package manager the project uses — `pnpm spree <command>`, `npx spree <command>` or `yarn spree <command>`. Running it from `server/` works too. In a bare clone of this template (no parent project), use `npx @spree/cli <command>` from this directory.
- **Never run `bin/rails`, `bin/rake`, `rake`, `bundle`, `rspec`, `bin/setup`, `bin/dev`, `ruby` or `rails` directly** — not on the host and not through `docker compose exec`. They run against the wrong Ruby, the wrong database, or no database at all. Use the command from the table below.
- **Never call `docker compose` directly.** The CLI picks the right compose files and environment.
- **Don't use the project root's `package.json` scripts** (`pnpm dev`, `npm run console`, …). They are shortcuts for humans that wrap the CLI — call the CLI command itself.
- When no dedicated command exists, fall back to `spree rails <args>`, `spree rake <task>` or `spree exec <command>`, which run inside the container.

| Instead of | Run |
| --- | --- |
| `bin/setup`, `bin/dev`, `docker compose up` | `spree dev` |
| `bin/rails console` | `spree console` |
| `bin/rails db:migrate` | `spree migrate` |
| `bin/rails db:rollback` | `spree migrate:rollback` |
| `bin/rails db:migrate:status` | `spree migrate:status` |
| `bin/rails db:seed` | `spree seed` |
| `bin/rails generate …` | `spree generate …` (Spree generators need no `spree:` prefix) |
| `bin/rails routes` | `spree routes` |
| `bin/rake spree:<task>` | `spree task <task>` |
| `bundle install`, `bundle add <gem>` | `spree bundle install`, `spree bundle add <gem>` |
| `bundle exec rspec …` | `spree rspec …` |
| `tail -f log/development.log` | `spree logs` |
| `psql` | `spree db:console` |
| Any other `bin/rails` command | `spree rails <args>` |

Full command reference: `spree --help`, or the [CLI guide](https://spreecommerce.org/docs/developer/cli/quickstart).

### Running the app

- `spree dev` runs in the foreground and streams logs until stopped. The developer usually has it running already — don't start a second copy. If you must start it yourself, run it as a background process (your agent's background mode, or shell job control) and pass `--no-open` so it doesn't open a browser — the flag does not detach it.
- After changing an initializer or anything else that does not reload on its own: `spree restart`.
- After changing the `Gemfile`: `spree bundle install`, then stop and start `spree dev` again.
- After changing the `Dockerfile` or `.ruby-version`: `spree build`.
- Never run `spree db:reset` or `spree eject` without asking the developer first.

### Your code changes only take effect in an ejected project

The Spree CLI runs whatever `docker-compose.yml` describes, and out of the box that is the prebuilt Spree Docker image — both in a new create-spree-app project and in a bare clone of this template. Until the project is ejected, edits to this directory — including files written by `spree generate` and gems added with `spree bundle` — have no effect. `spree eject` switches `docker-compose.yml` to build from this directory, with live reloading. You can tell a project is ejected when its `docker-compose.yml` mounts the source into the container: `./server:/rails` in a create-spree-app project, `.:/rails` in a bare clone.

Ejecting switches the app to a fresh development database, so ask the developer before running it.

## Spree Documentation

If `@spree/docs` is installed (create-spree-app adds it to the project root's `package.json`), the full developer documentation is available as Markdown in `../node_modules/@spree/docs/dist/`:

- `developer/core-concepts/` — products, orders, payments, inventory, and the rest of the data model
- `developer/customization/` — events, workflow hooks, dependencies, extensions, decorators
- `developer/cli/` — every Spree CLI command
- `api-reference/store.yaml`, `api-reference/admin.yaml` — OpenAPI specs for the Store API and Admin API, with every endpoint, parameter and response schema

Otherwise, use:

- https://spreecommerce.org/docs/llms.txt — links to every documentation page as Markdown
- https://spreecommerce.org/docs/api-reference/store.yaml and https://spreecommerce.org/docs/api-reference/admin.yaml — the API specs

For deeper guidance, install the Spree agent skills from the project root: `npx skills add spree/agent-skills`.

## Architecture

- An API-only Rails application with the Spree engines mounted
- Store API v3 at `/api/v3/store/` (customer-facing, publishable `pk_` keys) and Admin API v3 at `/api/v3/admin/` (back office, secret `sk_` keys or admin sign-in)
- The React Admin Dashboard at `/dashboard`, served by `spree_dashboard`; it talks only to the Admin API. `/` redirects to it
- Background jobs run on Solid Queue inside Puma and are stored in Postgres; the jobs dashboard is at `/jobs`
- Product search runs on the database by default; the optional Meilisearch provider (`spree_meilisearch`) turns on when `MEILISEARCH_URL` is set

## Key Files

| File | Purpose |
|------|---------|
| `config/initializers/spree.rb` | Spree configuration, subscribers, hooks, dependencies, permissions |
| `config/routes.rb` | Route mounting |
| `Gemfile` | Spree gems and extensions |
| `../.env` (or `.env` in a bare clone) | Environment variables |

## Customization Patterns

Use these in this order. Decorators are a last resort: they couple your code to Spree internals and make upgrades harder.

### 1. Events and subscribers (preferred for side effects)

React to changes without touching Spree code — syncing to external services, sending notifications, clearing caches.

Generate one with `spree generate subscriber OrderPlaced order.placed`. It writes the class and a spec, and registers the subscriber in `config/initializers/spree.rb` (subscribers are not discovered automatically).

```ruby
# app/subscribers/order_placed_subscriber.rb
class OrderPlacedSubscriber < Spree::Subscriber
  subscribes_to 'order.placed'

  def handle(event)
    order = Spree::Order.find_by_prefix_id(event.payload['id'])
    return unless order

    ExternalService.notify(order)
  end
end
```

### 2. Workflow hooks, then replacing a workflow

To run your own code inside a Spree flow (validate, react, add data), register a hook. Hooks survive upgrades:

```ruby
# config/initializers/spree.rb
Spree.hooks.register('carts.add_item.validate', 'MyApp::CheckPurchaseLimit')
```

```ruby
# app/services/my_app/check_purchase_limit.rb
module MyApp
  class CheckPurchaseLimit
    def call(workflow)
      return if workflow.quantity <= 10

      workflow.errors.add(:quantity, :purchase_limit_exceeded, message: 'You can order at most 10 of this item.')
      workflow.reject!
    end
  end
end
```

Only when no hook fits, replace the whole workflow by subclassing it:

```ruby
# app/workflows/my_app/carts/add_item.rb
module MyApp
  module Carts
    class AddItem < Spree::Carts::AddItem
      workflow_key 'carts.add_item' # keeps hooks registered on the original key firing

      def perform(variant:, cart: nil, **rest)
        super
        # your logic
      end
    end
  end
end
```

```ruby
# config/initializers/spree.rb
Spree.dependencies do |dependencies|
  dependencies.cart_add_item_workflow = 'MyApp::Carts::AddItem'
end
```

### 3. Extensions

Add the gem with `spree bundle add <extension>`, run its installer with `spree generate <extension>:install`, then restart `spree dev`.

### 4. Decorators (last resort)

Only for structural changes such as associations, validations and scopes. Never for callbacks or side effects — use a subscriber or a hook instead. Generate one with `spree generate model_decorator Spree::Product`.

```ruby
# app/models/spree/product_decorator.rb
module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :reviews, class_name: 'MyApp::Review', dependent: :destroy
      base.validates :custom_field, presence: true
    end
  end

  Product.prepend ProductDecorator
end
```

## Coding Conventions

- All custom code goes in `app/` — never modify gem source
- Use `Spree.customer_class` and `Spree.admin_user_class` — never reference the customer or admin user model directly (`Spree.user_class` is deprecated)
- All Spree models are namespaced under `Spree::` (for example `Spree::Product`, `Spree::Order`)
- Use `Spree::Current.store`, `Spree::Current.currency` and `Spree::Current.locale` for request context
- The APIs use prefixed IDs (for example `prod_86Rf07xd4z`) — never expose raw database IDs
- Publish events for side effects: `order.publish_event('order.placed')`
- Records move between statuses through workflows; Spree 6 has no state machines
- CanCanCan for authorization, Ransack for filtering, Pagy for pagination

## Testing

```bash
spree rails db:test:prepare                 # once, to create the test database
spree rspec                                 # full suite
spree rspec spec/models/                    # one directory
spree rspec spec/models/my_model_spec.rb:15 # one file or example
```

`spree rspec` runs inside the container with `RAILS_ENV=test`, against the `spree_test` database — never your development data.
