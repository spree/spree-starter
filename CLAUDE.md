# Spree Commerce Backend

This is a Rails application powered by [Spree Commerce](https://spreecommerce.org).

## Spree Documentation

If `@spree/docs` is installed (via the parent project's `package.json`), full developer docs are at:
`../node_modules/@spree/docs/dist/`

Key resources:
- `dist/developer/core-concepts/` — Products, orders, payments, inventory, etc.
- `dist/developer/customization/` — Decorators, extensions, configuration, dependencies
- `dist/api-reference/store.yaml` — OpenAPI 3.0 spec with all Store API endpoints, parameters, and response schemas. Read this when working on API integrations or building against the Store API.

Otherwise, refer to:
- https://spreecommerce.org/docs/llms.txt - links to all documentation pages in markdown
- https://spreecommerce.org/docs/api-reference/store.yaml - Store API OpenAPI 3.0 spec

## Architecture

- Rails app with Spree engines mounted at `/`
- Admin dashboard at `/admin`
- Store API v3 at `/api/v3/store/`
- Admin API v3 at `/api/v3/admin/`
- Background jobs via Solid Queue (in Postgres, runs inside Puma by default) — dashboard at `/jobs`
- Product search runs on the database by default; optional Meilisearch provider activates when `MEILISEARCH_URL` is set (compose service ships commented out)

## Key Files

| File | Purpose |
|------|---------|
| `config/initializers/spree.rb` | Spree configuration, dependencies, permissions |
| `config/routes.rb` | Route mounting and authentication |
| `Gemfile` | Spree gem versions and extensions |
| `.env` | Environment variables (`SPREE_PATH` for local dev) |

## Customization Patterns

MUST use this in this order — decorators should be a last resort as they couple your code to Spree internals and make upgrades harder.

### 1. Events & Subscribers (preferred for side effects)

React to model changes without touching Spree source. Use for syncing to external services, sending notifications, updating caches, etc.

```ruby
# app/subscribers/spree/my_order_subscriber.rb
module MyApp
  class OrderSubscriber < Spree::Subscriber
    subscribes_to 'order.complete'

    def handle(event)
      order = Spree::Order.find_by_prefix_id(event.payload['id'])
      ExternalService.notify(order)
    end
  end
end
```

Register in `config/initializers/spree.rb`:

```ruby
Rails.application.config.after_initialize do
  Spree.subscribers << MyApp::OrderSubscriber
end
```

### 2. Swapping Services (Dependencies)

Create a new service inheritting from Spree service, eg.

```ruby
module MyApp
  module Cart
    class AddItem < Spree::Cart::AddItem
      def call(order:, variant:, quantity: nil, metadata: {}, public_metadata: {}, private_metadata: {}, options: {})
        ApplicationRecord.transaction do
          run :add_to_line_item
          run :my_app_custom_logic_here
          run Spree.cart_recalculate_service
        end
      end
      
      def my_app_custom_logic_here
        # ...
      end
    end
  end
end
```

Regiser in `config/initializers/spree.rb`:

```ruby
Spree.dependencies do |dependencies|
  dependencies.cart_add_item_service = 'MyApp::Cart::AddItem'
end
```

### 3. Adding Extensions

Add to `Gemfile`

```ruby
gem 'spree_stripe'
```

Run `bundle install`

Run extension installator. eg `bin/rails g spree_stripe:install`
Convention is `bin/rails g <extension_name>:install`

### 4. Decorators (last resort)

Only use for structural changes (adding associations, validations, scopes). Avoid for callbacks and side effects — use subscribers instead.

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

## Development

```bash
bin/setup              # Install dependencies, prepare database, index search
bin/dev                # Start web (jobs run in-process) + admin CSS watcher
bin/rails console      # Rails console
bin/rails db:migrate   # Run migrations
bin/rails db:seed      # Seed the databases
```

## Coding Conventions

- All custom code goes in `app/` — never modify gem source
- Use decorators in `app/models/spree/` for model extensions
- Use `Spree.user_class` / `Spree.admin_user_class` — never reference `Spree::User` directly
- All Spree models are namespaced under `Spree::` (e.g., `Spree::Product`, `Spree::Order`)
- Use `Spree::Current.store`, `Spree::Current.currency`, `Spree::Current.locale` for request context
- Prefixed IDs in API (e.g., `prod_86Rf07xd4z`) — never expose raw database IDs
- Events system for side effects: `order.publish_event('order.completed')`
- CanCanCan for authorization, Ransack for filtering, Pagy for pagination

## Testing

Native (host Ruby):

```bash
bundle exec rspec                           # Full test suite
bundle exec rspec spec/models/              # Model specs only
bundle exec rspec spec/models/my_model.rb   # Single file
```

Docker (via `@spree/cli`): `spree rspec …` runs the same commands inside the web container with `RAILS_ENV=test`, against the `spree_test` database. First run: `spree rails db:test:prepare`.
