# frozen_string_literal: true

# Spree settings are configured with environment variables — see
# https://spreecommerce.org/docs/developer/customization/configuration
# for every setting and the variable that sets it.
#
#   SPREE_MINIMUM_PASSWORD_LENGTH=10
#
# Anything that shapes how a shop sells — currency, taxes, when customers are
# charged — belongs to the store and is edited in the dashboard, not here.
#
# Use a Spree.config block only for a value that has to be computed in Ruby;
# it is applied at boot and wins over the environment.
#
# Spree.config do |config|
#   config.minimum_password_length = 10
# end

# Swap a Spree service or workflow for your own — see
# https://spreecommerce.org/docs/developer/customization/dependencies
# Prefer a workflow hook when you only need to run code inside an existing flow:
# https://spreecommerce.org/docs/developer/customization/workflows
Spree.dependencies do |dependencies|
  # Example:
  # dependencies.cart_add_item_workflow = 'MyApp::Carts::AddItem'
end

# Workflow hooks, e.g.
# Spree.hooks.register('carts.add_item.validate', 'MyApp::CheckPurchaseLimit')

Rails.application.config.after_initialize do
  # Payment methods and shipping calculators
  # Spree.payment_methods << Spree::PaymentMethods::VerySafeAndReliablePaymentMethod
  # Spree.calculators.shipping_methods << Spree::ShippingMethods::SuperExpensiveNotVeryFastShipping
  # Spree.calculators.tax_rates << Spree::TaxRates::FinanceTeamForcedMeToCodeThis

  # Stock splitters and adjusters
  # Spree.stock_splitters << Spree::Stock::Splitters::SecretLogicSplitter
  # Spree.adjusters << Spree::Adjustable::Adjuster::TaxTheRich

  # Custom promotions
  # Spree.calculators.promotion_actions_create_adjustments << Spree::Calculators::PromotionActions::CreateAdjustments::AddDiscountForFriends
  # Spree.calculators.promotion_actions_create_item_adjustments << Spree::Calculators::PromotionActions::CreateItemAdjustments::FinanceTeamForcedMeToCodeThis
  # Spree.promotions.rules << Spree::Promotions::Rules::OnlyForVIPCustomers
  # Spree.promotions.actions << Spree::Promotions::Actions::GiftWithPurchase

  # Automatic collection rules
  # Rails.application.config.spree.collection_rules << Spree::CollectionRules::ProductsWithColor

  # Exports
  # Spree.export_types << Spree::Exports::Payments

  # Event subscribers (generate with `spree generate subscriber`, which also registers them here)
  # Spree.subscribers << OrderPlacedSubscriber
end

Spree.customer_class = 'Spree::Customer'
Spree.admin_user_class = 'Spree::AdminUser'

# Serve Active Storage attachment URLs (product images, logos, etc.) from a CDN
# host instead of the application host. Host only, no protocol — the scheme
# comes from routes.default_url_options (see config/environments/production.rb).
Spree.cdn_host = ENV['CDN_HOST'] if ENV['CDN_HOST'].present?

# Background job queue configuration
#
# Every Spree queue gets its own name so config/queue.yml can order them
# (checkout-critical first, bulk catalog work later). Any queue assigned here
# must also be listed in config/queue.yml — under Sidekiq, in
# config/sidekiq.yml, where an unlisted queue never runs.
Spree.queues.default = :default
Spree.queues.addresses = :spree_addresses
Spree.queues.api_keys = :spree_api_keys
Spree.queues.categories = :spree_categories
Spree.queues.collections = :spree_collections
Spree.queues.coupon_codes = :spree_coupon_codes
Spree.queues.data_requests = :spree_data_requests
Spree.queues.events = :spree_events
Spree.queues.exports = :spree_exports
Spree.queues.gift_cards = :spree_gift_cards
Spree.queues.images = :spree_images
Spree.queues.imports = :spree_imports
Spree.queues.payment_webhooks = :spree_payment_webhooks
Spree.queues.payouts = :spree_payouts
Spree.queues.products = :spree_products
Spree.queues.search = :spree_search
Spree.queues.stock_location_stock_levels = :spree_stock_location_stock_levels
Spree.queues.stock_reservations = :spree_stock_reservations
Spree.queues.tax_identifiers = :spree_tax_identifiers
Spree.queues.variants = :spree_variants
Spree.queues.webhooks = :spree_webhooks

# Search provider
if ENV['MEILISEARCH_URL'].present?
  Spree.search_provider = 'SpreeMeilisearch::SearchProvider'
end
