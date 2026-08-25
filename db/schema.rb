# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_25_150003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "locale", default: "en", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name", "locale"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

  create_table "action_text_video_embeds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "raw_html", null: false
    t.string "thumbnail_url", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.string "locale"
    t.string "scope"
    t.string "slug", null: false
    t.bigint "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.index ["deleted_at"], name: "index_friendly_id_slugs_on_deleted_at"
    t.index ["locale"], name: "index_friendly_id_slugs_on_locale"
    t.index ["slug", "sluggable_type", "locale"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_locale"
    t.index ["slug", "sluggable_type", "scope", "locale"], name: "index_friendly_id_slugs_unique", unique: true
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "solid_cable_messages", force: :cascade do |t|
    t.binary "channel", null: false
    t.bigint "channel_hash", null: false
    t.datetime "created_at", null: false
    t.binary "payload", null: false
    t.index ["channel"], name: "index_solid_cable_messages_on_channel"
    t.index ["channel_hash"], name: "index_solid_cable_messages_on_channel_hash"
    t.index ["created_at"], name: "index_solid_cable_messages_on_created_at"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
  end

  create_table "spree_addresses", force: :cascade do |t|
    t.string "address1"
    t.string "address2"
    t.string "alternative_phone"
    t.string "city"
    t.string "company"
    t.string "country_code"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.datetime "deleted_at", precision: nil
    t.string "firstname"
    t.string "label"
    t.string "lastname"
    t.decimal "latitude"
    t.decimal "longitude"
    t.jsonb "metadata"
    t.string "phone"
    t.boolean "quick_checkout", default: false
    t.string "state_code"
    t.bigint "state_id"
    t.string "state_name"
    t.datetime "updated_at", null: false
    t.string "zipcode"
    t.index ["country_code"], name: "index_spree_addresses_on_country_code"
    t.index ["country_id"], name: "index_spree_addresses_on_country_id"
    t.index ["customer_id"], name: "index_spree_addresses_on_customer_id"
    t.index ["deleted_at"], name: "index_spree_addresses_on_deleted_at"
    t.index ["firstname"], name: "index_addresses_on_firstname"
    t.index ["lastname"], name: "index_addresses_on_lastname"
    t.index ["quick_checkout"], name: "index_spree_addresses_on_quick_checkout"
    t.index ["state_id"], name: "index_spree_addresses_on_state_id"
  end

  create_table "spree_adjustments", force: :cascade do |t|
    t.bigint "adjustable_id"
    t.string "adjustable_type"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.boolean "eligible", default: true
    t.boolean "included", default: false
    t.string "label"
    t.boolean "mandatory"
    t.bigint "order_id", null: false
    t.bigint "source_id"
    t.string "source_type"
    t.string "state"
    t.datetime "updated_at", null: false
    t.index ["adjustable_id", "adjustable_type"], name: "index_spree_adjustments_on_adjustable_id_and_adjustable_type"
    t.index ["adjustable_type", "adjustable_id", "source_type"], name: "index_spree_adjustments_on_adjustable_and_source_type"
    t.index ["amount"], name: "index_spree_adjustments_on_amount"
    t.index ["eligible"], name: "index_spree_adjustments_on_eligible"
    t.index ["order_id", "eligible", "source_type"], name: "index_spree_adjustments_on_order_eligible_source_type"
    t.index ["order_id", "state"], name: "index_spree_adjustments_on_order_id_and_state"
    t.index ["order_id"], name: "index_spree_adjustments_on_order_id"
    t.index ["source_id", "source_type"], name: "index_spree_adjustments_on_source_id_and_source_type"
    t.index ["source_type"], name: "index_spree_adjustments_on_source_type"
  end

  create_table "spree_admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "failed_attempts"
    t.string "first_name"
    t.string "last_name"
    t.datetime "locked_at"
    t.string "login"
    t.jsonb "metadata"
    t.string "password_digest"
    t.string "selected_locale"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_spree_admin_users_on_email", unique: true
  end

  create_table "spree_allowed_origins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "origin", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "origin"], name: "index_spree_allowed_origins_on_store_id_and_origin", unique: true
    t.index ["store_id"], name: "index_spree_allowed_origins_on_store_id"
  end

  create_table "spree_api_keys", force: :cascade do |t|
    t.bigint "channel_id"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "created_by_type"
    t.string "key_type", null: false
    t.datetime "last_used_at"
    t.string "name", null: false
    t.datetime "revoked_at"
    t.bigint "revoked_by_id"
    t.string "revoked_by_type"
    t.jsonb "scopes"
    t.bigint "store_id", null: false
    t.string "token"
    t.string "token_digest"
    t.string "token_prefix"
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_spree_api_keys_on_channel_id"
    t.index ["created_by_type", "created_by_id"], name: "index_spree_api_keys_on_created_by"
    t.index ["key_type"], name: "index_spree_api_keys_on_key_type"
    t.index ["revoked_by_type", "revoked_by_id"], name: "index_spree_api_keys_on_revoked_by"
    t.index ["store_id", "key_type"], name: "index_spree_api_keys_on_store_id_and_key_type"
    t.index ["store_id"], name: "index_spree_api_keys_on_store_id"
    t.index ["token"], name: "index_spree_api_keys_on_token", unique: true, where: "(token IS NOT NULL)"
    t.index ["token_digest"], name: "index_spree_api_keys_on_token_digest", unique: true
  end

  create_table "spree_calculators", force: :cascade do |t|
    t.bigint "calculable_id"
    t.string "calculable_type"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "preferences"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["calculable_id", "calculable_type"], name: "index_spree_calculators_on_calculable_id_and_calculable_type"
    t.index ["deleted_at"], name: "index_spree_calculators_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_calculators_on_id_and_type"
  end

  create_table "spree_carts", force: :cascade do |t|
    t.boolean "accept_marketing"
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "bill_address_id"
    t.bigint "channel_id", null: false
    t.bigint "company_id"
    t.datetime "completed_at"
    t.datetime "completing_at"
    t.string "coupon_code"
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "customer_id"
    t.text "customer_note"
    t.decimal "delivery_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount_total", precision: 10, scale: 2, default: "0.0"
    t.string "email"
    t.decimal "fee_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "gift_card_id"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "item_total", precision: 10, scale: 2, default: "0.0"
    t.string "last_ip_address"
    t.string "locale", null: false
    t.integer "lock_version", default: 0
    t.bigint "market_id", null: false
    t.jsonb "metadata"
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "payment_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "preferred_stock_location_id"
    t.bigint "ship_address_id"
    t.bigint "store_id", null: false
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.string "token", null: false
    t.decimal "total", precision: 10, scale: 2, default: "0.0"
    t.integer "total_quantity", default: 0
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_spree_carts_on_channel_id"
    t.index ["company_id"], name: "index_spree_carts_on_company_id"
    t.index ["completed_at"], name: "index_spree_carts_on_completed_at"
    t.index ["customer_id"], name: "index_spree_carts_on_customer_id"
    t.index ["gift_card_id"], name: "index_spree_carts_on_gift_card_id"
    t.index ["market_id"], name: "index_spree_carts_on_market_id"
    t.index ["store_id"], name: "index_spree_carts_on_store_id"
    t.index ["token"], name: "index_spree_carts_on_token", unique: true
    t.index ["updated_at"], name: "index_spree_carts_on_updated_at"
  end

  create_table "spree_catalog_assignments", force: :cascade do |t|
    t.bigint "assignable_id", null: false
    t.string "assignable_type", null: false
    t.bigint "catalog_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_spree_catalog_assignments_on_assignable"
    t.index ["catalog_id", "assignable_type", "assignable_id"], name: "idx_catalog_assignments_uniqueness", unique: true
    t.index ["catalog_id"], name: "index_spree_catalog_assignments_on_catalog_id"
  end

  create_table "spree_catalog_products", force: :cascade do |t|
    t.bigint "catalog_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["catalog_id", "product_id"], name: "idx_catalog_products_on_catalog_and_product", unique: true
    t.index ["catalog_id"], name: "index_spree_catalog_products_on_catalog_id"
    t.index ["product_id"], name: "index_spree_catalog_products_on_product_id"
  end

  create_table "spree_catalogs", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name", null: false
    t.integer "position"
    t.bigint "price_list_id"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["price_list_id"], name: "index_spree_catalogs_on_price_list_id"
    t.index ["store_id"], name: "index_spree_catalogs_on_store_id"
  end

  create_table "spree_categories", force: :cascade do |t|
    t.boolean "automatic", default: false, null: false
    t.integer "children_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "depth"
    t.text "description"
    t.boolean "hide_from_nav", default: false
    t.bigint "lft"
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.jsonb "metadata"
    t.string "name", null: false
    t.bigint "parent_id"
    t.string "permalink"
    t.integer "position", default: 0
    t.string "pretty_name"
    t.integer "products_count", default: 0, null: false
    t.bigint "rgt"
    t.string "rules_match_policy", default: "all", null: false
    t.string "sort_order", default: "manual", null: false
    t.bigint "store_id"
    t.bigint "taxonomy_id"
    t.datetime "updated_at", null: false
    t.index ["children_count"], name: "index_spree_categories_on_children_count"
    t.index ["lft"], name: "index_spree_categories_on_lft"
    t.index ["name"], name: "index_spree_categories_on_name"
    t.index ["parent_id"], name: "index_taxons_on_parent_id"
    t.index ["permalink", "store_id"], name: "index_spree_categories_on_permalink_and_store_id", unique: true
    t.index ["permalink"], name: "index_taxons_on_permalink"
    t.index ["position"], name: "index_spree_categories_on_position"
    t.index ["pretty_name"], name: "index_spree_categories_on_pretty_name"
    t.index ["products_count"], name: "index_spree_categories_on_products_count"
    t.index ["rgt"], name: "index_spree_categories_on_rgt"
    t.index ["store_id"], name: "index_spree_categories_on_store_id"
    t.index ["taxonomy_id"], name: "index_taxons_on_taxonomy_id"
  end

  create_table "spree_category_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "locale", null: false
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.string "name"
    t.string "permalink"
    t.string "pretty_name"
    t.bigint "spree_category_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_category_translations_on_locale"
    t.index ["pretty_name"], name: "index_spree_category_translations_on_pretty_name"
    t.index ["spree_category_id", "locale"], name: "idx_on_spree_category_id_locale_5fb02d0070", unique: true
  end

  create_table "spree_channel_stock_locations", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.bigint "stock_location_id", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id", "stock_location_id"], name: "idx_channel_stock_locations_uniqueness", unique: true
    t.index ["channel_id"], name: "index_spree_channel_stock_locations_on_channel_id"
    t.index ["stock_location_id"], name: "index_spree_channel_stock_locations_on_stock_location_id"
  end

  create_table "spree_channels", force: :cascade do |t|
    t.boolean "active", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.bigint "default_catalog_id"
    t.string "name", null: false
    t.text "preferences"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["default_catalog_id"], name: "index_spree_channels_on_default_catalog_id"
    t.index ["store_id", "code"], name: "index_spree_channels_on_store_id_and_code", unique: true
    t.index ["store_id"], name: "index_spree_channels_default_per_store", unique: true, where: "(\"default\" = true)"
    t.index ["store_id"], name: "index_spree_channels_on_store_id"
  end

  create_table "spree_claim_line_items", force: :cascade do |t|
    t.bigint "claim_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "line_item_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "refund_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "replacement_variant_id"
    t.boolean "send_replacement", default: false, null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["claim_id"], name: "index_spree_claim_line_items_on_claim_id"
    t.index ["line_item_id"], name: "index_spree_claim_line_items_on_line_item_id"
    t.index ["replacement_variant_id"], name: "index_spree_claim_line_items_on_replacement_variant_id"
    t.index ["variant_id"], name: "index_spree_claim_line_items_on_variant_id"
  end

  create_table "spree_claim_reasons", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "name"], name: "index_spree_claim_reasons_on_store_id_and_name", unique: true
    t.index ["store_id"], name: "index_spree_claim_reasons_on_store_id"
  end

  create_table "spree_claims", force: :cascade do |t|
    t.datetime "approved_at"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.datetime "denied_at"
    t.text "memo"
    t.jsonb "metadata"
    t.string "number", null: false
    t.bigint "order_id", null: false
    t.bigint "reason_id"
    t.string "resolution"
    t.datetime "resolved_at"
    t.string "status", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_spree_claims_on_created_by_id"
    t.index ["number"], name: "index_spree_claims_on_number", unique: true
    t.index ["order_id"], name: "index_spree_claims_on_order_id"
    t.index ["reason_id"], name: "index_spree_claims_on_reason_id"
    t.index ["status"], name: "index_spree_claims_on_status"
    t.index ["store_id"], name: "index_spree_claims_on_store_id"
  end

  create_table "spree_collection_rules", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.string "match_policy", default: "is_equal_to", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["collection_id", "type"], name: "index_spree_collection_rules_on_collection_id_and_type"
    t.index ["collection_id"], name: "index_spree_collection_rules_on_collection_id"
  end

  create_table "spree_collection_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "locale", null: false
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.string "name"
    t.string "permalink"
    t.bigint "spree_collection_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_collection_translations_on_locale"
    t.index ["spree_collection_id", "locale"], name: "index_collection_translations_on_collection_and_locale", unique: true
  end

  create_table "spree_collections", force: :cascade do |t|
    t.boolean "automatic", default: false, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.jsonb "metadata"
    t.string "name", null: false
    t.string "permalink"
    t.integer "position"
    t.integer "products_count", default: 0, null: false
    t.string "rules_match_policy", default: "all", null: false
    t.string "sort_order", default: "manual", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "permalink"], name: "index_spree_collections_on_store_id_and_permalink", unique: true
    t.index ["store_id"], name: "index_spree_collections_on_store_id"
  end

  create_table "spree_commission_lines", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "commission_rate_id"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "fulfillment_id"
    t.string "kind", null: false
    t.bigint "line_item_id"
    t.jsonb "metadata"
    t.bigint "order_id", null: false
    t.decimal "rate", precision: 8, scale: 5, default: "0.0", null: false
    t.bigint "seller_id", null: false
    t.string "state_code"
    t.decimal "tax_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "tax_rate", precision: 8, scale: 5, default: "0.0", null: false
    t.string "taxability_reason"
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["commission_rate_id"], name: "index_spree_commission_lines_on_commission_rate_id"
    t.index ["country_code", "state_code"], name: "index_spree_commission_lines_on_country_code_and_state_code"
    t.index ["fulfillment_id"], name: "index_commission_lines_on_fulfillment", unique: true
    t.index ["line_item_id"], name: "index_commission_lines_on_line_item", unique: true
    t.index ["order_id"], name: "index_spree_commission_lines_on_order_id"
    t.index ["seller_id", "created_at"], name: "index_spree_commission_lines_on_seller_id_and_created_at"
    t.index ["seller_id"], name: "index_spree_commission_lines_on_seller_id"
    t.index ["taxability_reason"], name: "index_spree_commission_lines_on_taxability_reason"
    t.check_constraint "(line_item_id IS NULL) <> (fulfillment_id IS NULL)", name: "chk_spree_commission_lines_one_subject"
  end

  create_table "spree_commission_rate_values", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "commission_rate_id", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.datetime "deleted_at"
    t.decimal "max_amount", precision: 10, scale: 2
    t.decimal "min_amount", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["commission_rate_id", "currency"], name: "index_commission_rate_values_on_rate_and_currency", unique: true, where: "(deleted_at IS NULL)"
    t.index ["commission_rate_id"], name: "index_spree_commission_rate_values_on_commission_rate_id"
    t.index ["deleted_at"], name: "index_spree_commission_rate_values_on_deleted_at"
  end

  create_table "spree_commission_rates", force: :cascade do |t|
    t.string "code"
    t.decimal "commission_tax_rate", precision: 8, scale: 5
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.boolean "enabled", default: true, null: false
    t.boolean "include_shipping", default: false, null: false
    t.string "kind", null: false
    t.jsonb "metadata"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.bigint "store_id", null: false
    t.boolean "tax_inclusive", default: false, null: false
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 5, default: "0.0", null: false
    t.index ["deleted_at"], name: "index_spree_commission_rates_on_deleted_at"
    t.index ["store_id", "code"], name: "index_spree_commission_rates_on_store_id_and_code", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id", "enabled", "position"], name: "idx_on_store_id_enabled_position_2e416afa00"
    t.index ["store_id"], name: "index_spree_commission_rates_on_store_id"
  end

  create_table "spree_commission_rule_products", force: :cascade do |t|
    t.bigint "commission_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["commission_rule_id", "product_id"], name: "index_commission_rule_products_on_rule_and_product", unique: true, where: "(deleted_at IS NULL)"
    t.index ["commission_rule_id"], name: "index_spree_commission_rule_products_on_commission_rule_id"
    t.index ["deleted_at"], name: "index_spree_commission_rule_products_on_deleted_at"
    t.index ["product_id"], name: "index_spree_commission_rule_products_on_product_id"
  end

  create_table "spree_commission_rules", force: :cascade do |t|
    t.bigint "commission_rate_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.jsonb "preferences"
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["commission_rate_id", "type"], name: "index_commission_rules_on_rate_and_type", unique: true, where: "(deleted_at IS NULL)"
    t.index ["commission_rate_id"], name: "index_spree_commission_rules_on_commission_rate_id"
    t.index ["deleted_at"], name: "index_spree_commission_rules_on_deleted_at"
  end

  create_table "spree_companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.jsonb "metadata"
    t.string "name", null: false
    t.bigint "parent_id"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_spree_companies_on_parent_id"
    t.index ["store_id"], name: "index_spree_companies_on_store_id"
  end

  create_table "spree_company_addresses", force: :cascade do |t|
    t.bigint "address_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.boolean "default_billing", default: false, null: false
    t.boolean "default_shipping", default: false, null: false
    t.string "label"
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_spree_company_addresses_on_address_id"
    t.index ["company_id"], name: "idx_company_addresses_default_billing", unique: true, where: "(default_billing = true)"
    t.index ["company_id"], name: "idx_company_addresses_default_shipping", unique: true, where: "(default_shipping = true)"
    t.index ["company_id"], name: "index_spree_company_addresses_on_company_id"
  end

  create_table "spree_company_invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "email", null: false
    t.datetime "expires_at", null: false
    t.bigint "inviter_id"
    t.jsonb "metadata"
    t.datetime "revoked_at"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "email"], name: "index_spree_company_invitations_on_company_id_and_email"
    t.index ["company_id"], name: "index_spree_company_invitations_on_company_id"
    t.index ["customer_id"], name: "index_spree_company_invitations_on_customer_id"
    t.index ["inviter_id"], name: "index_spree_company_invitations_on_inviter_id"
    t.index ["token"], name: "index_spree_company_invitations_on_token", unique: true
  end

  create_table "spree_company_memberships", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "customer_id"], name: "idx_company_memberships_on_company_and_customer", unique: true
    t.index ["company_id"], name: "index_spree_company_memberships_on_company_id"
    t.index ["customer_id"], name: "index_spree_company_memberships_on_customer_id"
  end

  create_table "spree_consolidated_metadata_tables", force: :cascade do |t|
    t.string "table_name", null: false
  end

  create_table "spree_countries", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "iso", null: false
    t.string "iso3", null: false
    t.string "iso_name"
    t.string "name"
    t.integer "numcode"
    t.boolean "states_required", default: false
    t.datetime "updated_at", precision: nil
    t.boolean "zipcode_required", default: true
    t.index ["iso"], name: "index_spree_countries_on_iso", unique: true
    t.index ["iso3"], name: "index_spree_countries_on_iso3", unique: true
    t.index ["iso_name"], name: "index_spree_countries_on_iso_name", unique: true
    t.index ["name"], name: "index_spree_countries_on_name", unique: true
  end

  create_table "spree_coupon_codes", force: :cascade do |t|
    t.bigint "cart_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "order_id"
    t.bigint "promotion_id"
    t.integer "state", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_coupon_codes_on_cart_id"
    t.index ["code"], name: "index_spree_coupon_codes_on_code", unique: true
    t.index ["deleted_at"], name: "index_spree_coupon_codes_on_deleted_at"
    t.index ["order_id"], name: "index_spree_coupon_codes_on_order_id"
    t.index ["promotion_id"], name: "index_spree_coupon_codes_on_promotion_id"
    t.index ["state"], name: "index_spree_coupon_codes_on_state"
  end

  create_table "spree_credit_cards", force: :cascade do |t|
    t.bigint "address_id"
    t.string "cc_type"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.boolean "default", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.string "fingerprint"
    t.bigint "gateway_customer_id"
    t.string "gateway_customer_profile_id"
    t.string "gateway_payment_profile_id"
    t.string "last_digits"
    t.jsonb "metadata"
    t.string "month"
    t.string "name"
    t.bigint "payment_method_id"
    t.datetime "updated_at", null: false
    t.string "year"
    t.index ["address_id"], name: "index_spree_credit_cards_on_address_id"
    t.index ["customer_id", "payment_method_id", "fingerprint", "month", "year"], name: "index_spree_credit_cards_unique_fingerprint", unique: true, where: "((fingerprint IS NOT NULL) AND (deleted_at IS NULL))"
    t.index ["customer_id"], name: "index_spree_credit_cards_on_customer_id"
    t.index ["deleted_at"], name: "index_spree_credit_cards_on_deleted_at"
    t.index ["gateway_customer_id"], name: "index_spree_credit_cards_on_gateway_customer_id"
    t.index ["payment_method_id"], name: "index_spree_credit_cards_on_payment_method_id"
  end

  create_table "spree_custom_domains", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.jsonb "metadata"
    t.boolean "status", default: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["store_id"], name: "index_spree_custom_domains_on_store_id"
    t.index ["url"], name: "index_spree_custom_domains_on_url", unique: true
  end

  create_table "spree_custom_field_definitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "field_type", null: false
    t.string "key", null: false
    t.string "label", null: false
    t.string "namespace", null: false
    t.string "resource_type", null: false
    t.boolean "searchable"
    t.boolean "sortable"
    t.boolean "storefront_visible", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["namespace", "key"], name: "index_spree_custom_field_definitions_on_namespace_and_key"
    t.index ["resource_type", "namespace", "key"], name: "idx_on_resource_type_namespace_key_9d5a4e5186", unique: true
    t.index ["resource_type"], name: "index_spree_custom_field_definitions_on_resource_type"
  end

  create_table "spree_custom_fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "custom_field_definition_id", null: false
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["custom_field_definition_id"], name: "index_spree_custom_fields_on_custom_field_definition_id"
    t.index ["resource_type", "resource_id", "custom_field_definition_id"], name: "index_custom_fields_on_resource_and_definition", unique: true
    t.index ["resource_type", "resource_id"], name: "index_spree_metafields_on_resource"
    t.index ["type"], name: "index_spree_custom_fields_on_type"
  end

  create_table "spree_customer_group_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_group_id", null: false
    t.bigint "customer_id", null: false
    t.string "customer_type", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_group_id", "customer_id", "customer_type"], name: "index_spree_customer_group_users_unique", unique: true
    t.index ["customer_group_id"], name: "index_spree_customer_group_users_on_customer_group_id"
    t.index ["customer_type", "customer_id"], name: "index_spree_customer_group_users_on_user"
  end

  create_table "spree_customer_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.string "name", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_customer_groups_on_deleted_at"
    t.index ["store_id", "name"], name: "index_spree_customer_groups_on_store_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id"], name: "index_spree_customer_groups_on_store_id"
  end

  create_table "spree_customer_returns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "number"
    t.bigint "stock_location_id"
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_spree_customer_returns_on_number", unique: true
    t.index ["stock_location_id"], name: "index_spree_customer_returns_on_stock_location_id"
    t.index ["store_id"], name: "index_spree_customer_returns_on_store_id"
  end

  create_table "spree_customers", force: :cascade do |t|
    t.boolean "accepts_email_marketing", null: false
    t.bigint "bill_address_id"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.integer "failed_attempts"
    t.string "first_name"
    t.text "internal_note"
    t.string "last_name"
    t.datetime "locked_at"
    t.string "login"
    t.jsonb "metadata"
    t.string "password_digest"
    t.string "phone"
    t.jsonb "private_metadata"
    t.jsonb "public_metadata"
    t.string "selected_locale"
    t.bigint "ship_address_id"
    t.datetime "updated_at", null: false
    t.index ["accepts_email_marketing"], name: "index_spree_customers_on_accepts_email_marketing"
    t.index ["bill_address_id"], name: "index_spree_customers_on_bill_address_id"
    t.index ["email"], name: "index_spree_customers_on_email", unique: true
    t.index ["ship_address_id"], name: "index_spree_customers_on_ship_address_id"
  end

  create_table "spree_data_feeds", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.string "slug"
    t.bigint "store_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["store_id", "name"], name: "index_spree_data_feeds_on_store_id_and_name", unique: true
    t.index ["store_id", "slug", "type"], name: "index_spree_data_feeds_on_store_id_and_slug_and_type"
    t.index ["store_id", "slug"], name: "index_spree_data_feeds_on_store_id_and_slug", unique: true
    t.index ["store_id"], name: "index_spree_data_feeds_on_store_id"
  end

  create_table "spree_delivery_method_rule_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_method_rule_id", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_method_rule_id", "product_id"], name: "idx_delivery_method_rule_products_uniqueness", unique: true
    t.index ["product_id"], name: "index_spree_delivery_method_rule_products_on_product_id"
  end

  create_table "spree_delivery_method_rules", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.bigint "delivery_method_id", null: false
    t.jsonb "preferences"
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_method_id", "type"], name: "idx_delivery_method_rules_uniqueness", unique: true
    t.index ["delivery_method_id"], name: "index_spree_delivery_method_rules_on_delivery_method_id"
  end

  create_table "spree_delivery_method_services", force: :cascade do |t|
    t.string "carrier", null: false
    t.datetime "created_at", null: false
    t.bigint "delivery_method_id", null: false
    t.string "label"
    t.decimal "markup_flat", precision: 10, scale: 2
    t.decimal "markup_percent", precision: 8, scale: 2
    t.integer "position", default: 0
    t.string "service", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_method_id", "carrier", "service"], name: "idx_delivery_method_services_uniqueness", unique: true
    t.index ["delivery_method_id"], name: "index_spree_delivery_method_services_on_delivery_method_id"
  end

  create_table "spree_delivery_method_stock_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_method_id", null: false
    t.bigint "stock_location_id", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_method_id", "stock_location_id"], name: "idx_delivery_method_stock_locations_uniqueness", unique: true
    t.index ["stock_location_id"], name: "idx_on_stock_location_id_74b70de887"
  end

  create_table "spree_delivery_methods", force: :cascade do |t|
    t.string "admin_name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "delivery_origin_group_id"
    t.bigint "delivery_profile_id"
    t.bigint "delivery_zone_id"
    t.string "display_on"
    t.integer "estimated_transit_business_days_max"
    t.integer "estimated_transit_business_days_min"
    t.string "fulfillment_provider"
    t.decimal "markup_flat", precision: 10, scale: 2, default: "0.0"
    t.decimal "markup_percent", precision: 8, scale: 2, default: "0.0"
    t.jsonb "metadata"
    t.string "name"
    t.string "pickup_point_provider"
    t.string "rate_provider"
    t.bigint "store_id"
    t.boolean "storefront_visible", default: true, null: false
    t.bigint "tax_category_id"
    t.string "tracking_url"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_delivery_methods_on_deleted_at"
    t.index ["delivery_origin_group_id"], name: "index_spree_delivery_methods_on_delivery_origin_group_id"
    t.index ["delivery_profile_id"], name: "index_spree_delivery_methods_on_delivery_profile_id"
    t.index ["delivery_zone_id"], name: "index_spree_delivery_methods_on_delivery_zone_id"
    t.index ["store_id"], name: "index_spree_delivery_methods_on_store_id"
    t.index ["tax_category_id"], name: "index_spree_delivery_methods_on_tax_category_id"
  end

  create_table "spree_delivery_origin_group_locations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_origin_group_id", null: false
    t.bigint "stock_location_id", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_origin_group_id", "stock_location_id"], name: "idx_delivery_origin_group_locations_uniqueness", unique: true
    t.index ["delivery_origin_group_id"], name: "idx_on_delivery_origin_group_id_01bd160cac"
    t.index ["stock_location_id"], name: "idx_on_stock_location_id_7029c947c2"
  end

  create_table "spree_delivery_origin_groups", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_profile_id", null: false
    t.string "name"
    t.integer "position", default: 0
    t.datetime "updated_at", null: false
    t.index ["delivery_profile_id"], name: "index_spree_delivery_origin_groups_on_delivery_profile_id"
  end

  create_table "spree_delivery_profiles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.string "name"
    t.integer "position", default: 0
    t.bigint "store_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_spree_delivery_profiles_on_name"
    t.index ["store_id"], name: "index_spree_delivery_profiles_on_store_id"
    t.index ["type"], name: "index_spree_delivery_profiles_on_type"
  end

  create_table "spree_delivery_rates", force: :cascade do |t|
    t.string "carrier"
    t.decimal "cost", precision: 8, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.bigint "delivery_method_id"
    t.date "estimated_delivery_date"
    t.bigint "fulfillment_id"
    t.jsonb "metadata"
    t.string "name"
    t.boolean "selected", default: false
    t.string "service_level"
    t.bigint "tax_rate_id"
    t.datetime "updated_at", null: false
    t.index ["delivery_method_id"], name: "index_spree_delivery_rates_on_delivery_method_id"
    t.index ["fulfillment_id", "delivery_method_id"], name: "spree_delivery_rates_join_index"
    t.index ["fulfillment_id"], name: "index_spree_delivery_rates_on_fulfillment_id"
    t.index ["selected"], name: "index_spree_delivery_rates_on_selected"
    t.index ["tax_rate_id"], name: "index_spree_delivery_rates_on_tax_rate_id"
  end

  create_table "spree_delivery_zone_members", force: :cascade do |t|
    t.string "country_code"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.bigint "delivery_zone_id", null: false
    t.string "member_type", null: false
    t.string "postal_code_from"
    t.string "postal_code_prefix"
    t.string "postal_code_to"
    t.string "state_code"
    t.bigint "state_id"
    t.datetime "updated_at", null: false
    t.index ["country_code"], name: "index_spree_delivery_zone_members_on_country_code"
    t.index ["country_id"], name: "index_spree_delivery_zone_members_on_country_id"
    t.index ["delivery_zone_id"], name: "index_spree_delivery_zone_members_on_delivery_zone_id"
    t.index ["state_id"], name: "index_spree_delivery_zone_members_on_state_id"
  end

  create_table "spree_delivery_zones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_origin_group_id"
    t.bigint "delivery_profile_id"
    t.string "description"
    t.jsonb "metadata"
    t.string "name", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["delivery_origin_group_id"], name: "index_spree_delivery_zones_on_delivery_origin_group_id"
    t.index ["delivery_profile_id"], name: "index_spree_delivery_zones_on_delivery_profile_id"
    t.index ["store_id", "name"], name: "index_spree_delivery_zones_on_store_id_and_name", unique: true
    t.index ["store_id"], name: "index_spree_delivery_zones_on_store_id"
  end

  create_table "spree_digital_links", force: :cascade do |t|
    t.integer "access_counter"
    t.datetime "created_at", precision: nil, null: false
    t.bigint "digital_id"
    t.bigint "line_item_id"
    t.string "token"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["digital_id"], name: "index_spree_digital_links_on_digital_id"
    t.index ["line_item_id"], name: "index_spree_digital_links_on_line_item_id"
    t.index ["token"], name: "index_spree_digital_links_on_token", unique: true
  end

  create_table "spree_digitals", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "variant_id"
    t.index ["variant_id"], name: "index_spree_digitals_on_variant_id"
  end

  create_table "spree_discounts", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "cart_id"
    t.string "code"
    t.datetime "created_at", null: false
    t.bigint "fulfillment_id"
    t.string "kind", null: false
    t.string "label", null: false
    t.bigint "line_item_id"
    t.jsonb "metadata"
    t.bigint "order_id"
    t.bigint "promotion_action_id"
    t.bigint "promotion_id"
    t.datetime "updated_at", null: false
    t.decimal "value", precision: 10, scale: 2
    t.string "value_type"
    t.index ["cart_id"], name: "index_spree_discounts_on_cart_id"
    t.index ["code"], name: "index_spree_discounts_on_code"
    t.index ["fulfillment_id"], name: "index_spree_discounts_on_fulfillment_id"
    t.index ["line_item_id"], name: "index_spree_discounts_on_line_item_id"
    t.index ["order_id"], name: "index_spree_discounts_on_order_id"
    t.index ["promotion_action_id"], name: "index_spree_discounts_on_promotion_action_id"
    t.index ["promotion_id"], name: "index_spree_discounts_on_promotion_id"
    t.check_constraint "amount <= 0::numeric", name: "chk_spree_discounts_amount_nonpositive"
  end

  create_table "spree_exchange_line_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "exchange_id", null: false
    t.bigint "fulfillment_item_id", null: false
    t.bigint "line_item_id", null: false
    t.bigint "new_variant_id", null: false
    t.bigint "original_variant_id", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "received_quantity", default: 0, null: false
    t.boolean "resellable", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["exchange_id"], name: "index_spree_exchange_line_items_on_exchange_id"
    t.index ["fulfillment_item_id"], name: "index_spree_exchange_line_items_on_fulfillment_item_id"
    t.index ["line_item_id"], name: "index_spree_exchange_line_items_on_line_item_id"
    t.index ["new_variant_id"], name: "index_spree_exchange_line_items_on_new_variant_id"
    t.index ["original_variant_id"], name: "index_spree_exchange_line_items_on_original_variant_id"
  end

  create_table "spree_exchanges", force: :cascade do |t|
    t.datetime "approved_at"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.datetime "fulfilled_at"
    t.text "memo"
    t.jsonb "metadata"
    t.string "number", null: false
    t.bigint "order_id", null: false
    t.bigint "reason_id"
    t.datetime "received_at"
    t.string "status", null: false
    t.bigint "stock_location_id", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_spree_exchanges_on_created_by_id"
    t.index ["number"], name: "index_spree_exchanges_on_number", unique: true
    t.index ["order_id"], name: "index_spree_exchanges_on_order_id"
    t.index ["reason_id"], name: "index_spree_exchanges_on_reason_id"
    t.index ["status"], name: "index_spree_exchanges_on_status"
    t.index ["stock_location_id"], name: "index_spree_exchanges_on_stock_location_id"
    t.index ["store_id"], name: "index_spree_exchanges_on_store_id"
  end

  create_table "spree_exports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "format", null: false
    t.string "number", limit: 32, null: false
    t.text "preferences"
    t.jsonb "search_params"
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["format"], name: "index_spree_exports_on_format"
    t.index ["number"], name: "index_spree_exports_on_number", unique: true
    t.index ["store_id"], name: "index_spree_exports_on_store_id"
    t.index ["user_id"], name: "index_spree_exports_on_user_id"
  end

  create_table "spree_external_references", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id", null: false
    t.jsonb "metadata"
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.bigint "store_id", null: false
    t.string "system", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "idx_external_references_on_resource_lookup"
    t.index ["store_id", "system", "resource_type", "external_id"], name: "idx_external_references_on_external_id", unique: true
    t.index ["store_id", "system", "resource_type", "resource_id"], name: "idx_external_references_on_resource", unique: true
  end

  create_table "spree_fees", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.bigint "fulfillment_id"
    t.string "kind", null: false
    t.string "label", null: false
    t.bigint "line_item_id"
    t.jsonb "metadata"
    t.bigint "order_id"
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_fees_on_cart_id"
    t.index ["fulfillment_id"], name: "index_spree_fees_on_fulfillment_id"
    t.index ["line_item_id"], name: "index_spree_fees_on_line_item_id"
    t.index ["order_id", "kind"], name: "index_spree_fees_on_order_id_and_kind"
    t.check_constraint "amount >= 0::numeric", name: "chk_spree_fees_amount_nonnegative"
  end

  create_table "spree_fulfillment_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "fulfillment_id"
    t.bigint "line_item_id"
    t.bigint "order_id"
    t.bigint "original_return_item_id"
    t.boolean "pending", default: true
    t.integer "quantity", default: 1
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["fulfillment_id"], name: "index_spree_fulfillment_items_on_fulfillment_id"
    t.index ["line_item_id"], name: "index_spree_fulfillment_items_on_line_item_id"
    t.index ["order_id"], name: "index_spree_fulfillment_items_on_order_id"
    t.index ["original_return_item_id"], name: "index_spree_fulfillment_items_on_original_return_item_id"
    t.index ["variant_id"], name: "index_spree_fulfillment_items_on_variant_id"
  end

  create_table "spree_fulfillments", force: :cascade do |t|
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "address_id"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "cart_id"
    t.decimal "cost", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "delivered_at"
    t.datetime "estimated_delivery_at"
    t.datetime "fulfilled_at", precision: nil
    t.string "fulfillment_type"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.jsonb "metadata"
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "number"
    t.bigint "order_id"
    t.jsonb "pickup_point_data"
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.string "status"
    t.bigint "stock_location_id"
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "tracking"
    t.string "tracking_carrier"
    t.jsonb "tracking_details"
    t.string "tracking_status"
    t.datetime "updated_at", null: false
    t.index ["address_id"], name: "index_spree_fulfillments_on_address_id"
    t.index ["cart_id"], name: "index_spree_fulfillments_on_cart_id"
    t.index ["number"], name: "index_spree_fulfillments_on_number", unique: true
    t.index ["order_id"], name: "index_spree_fulfillments_on_order_id"
    t.index ["status"], name: "index_spree_fulfillments_on_status"
    t.index ["stock_location_id"], name: "index_spree_fulfillments_on_stock_location_id"
    t.index ["tracking"], name: "index_spree_fulfillments_on_tracking"
  end

  create_table "spree_gateway_customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.bigint "payment_method_id", null: false
    t.string "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "payment_method_id"], name: "idx_on_customer_id_payment_method_id_75005644af", unique: true
    t.index ["customer_id"], name: "index_spree_gateway_customers_on_customer_id"
    t.index ["payment_method_id"], name: "index_spree_gateway_customers_on_payment_method_id"
  end

  create_table "spree_gateways", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.text "description"
    t.string "environment", default: "development"
    t.string "name"
    t.text "preferences"
    t.string "server", default: "test"
    t.boolean "test_mode", default: true
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_spree_gateways_on_active"
    t.index ["test_mode"], name: "index_spree_gateways_on_test_mode"
  end

  create_table "spree_gift_card_batches", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "codes_count", default: 1, null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency", null: false
    t.date "expires_at"
    t.string "prefix"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_spree_gift_card_batches_on_created_by_id"
    t.index ["store_id"], name: "index_spree_gift_card_batches_on_store_id"
  end

  create_table "spree_gift_cards", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "amount_authorized", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "amount_used", precision: 10, scale: 2, default: "0.0", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency", null: false
    t.bigint "customer_id"
    t.date "expires_at"
    t.bigint "gift_card_batch_id"
    t.datetime "redeemed_at"
    t.string "status", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_spree_gift_cards_on_code", unique: true
    t.index ["created_by_id"], name: "index_spree_gift_cards_on_created_by_id"
    t.index ["customer_id"], name: "index_spree_gift_cards_on_customer_id"
    t.index ["expires_at"], name: "index_spree_gift_cards_on_expires_at"
    t.index ["gift_card_batch_id"], name: "index_spree_gift_cards_on_gift_card_batch_id"
    t.index ["redeemed_at"], name: "index_spree_gift_cards_on_redeemed_at"
    t.index ["status"], name: "index_spree_gift_cards_on_status"
    t.index ["store_id"], name: "index_spree_gift_cards_on_store_id"
  end

  create_table "spree_import_mappings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "file_column"
    t.bigint "import_id", null: false
    t.string "schema_field", null: false
    t.datetime "updated_at", null: false
    t.index ["file_column"], name: "index_spree_import_mappings_on_file_column"
    t.index ["import_id", "schema_field"], name: "index_spree_import_mappings_on_import_id_and_schema_field", unique: true
    t.index ["import_id"], name: "index_spree_import_mappings_on_import_id"
  end

  create_table "spree_import_rows", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "data", null: false
    t.bigint "import_id", null: false
    t.bigint "item_id"
    t.string "item_type"
    t.integer "row_number", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.text "validation_errors"
    t.index ["import_id", "row_number"], name: "index_spree_import_rows_on_import_id_and_row_number", unique: true
    t.index ["import_id", "status"], name: "index_spree_import_rows_on_import_id_and_status"
    t.index ["import_id"], name: "index_spree_import_rows_on_import_id"
    t.index ["item_type", "item_id"], name: "index_spree_import_rows_on_item"
    t.index ["status"], name: "index_spree_import_rows_on_status"
  end

  create_table "spree_imports", force: :cascade do |t|
    t.integer "completed_groups_count", default: 0
    t.datetime "created_at", null: false
    t.string "number", limit: 32, null: false
    t.bigint "owner_id", null: false
    t.string "owner_type", null: false
    t.text "preferences"
    t.text "processing_errors"
    t.integer "processing_groups_count", default: 0
    t.integer "rows_count", default: 0, null: false
    t.string "status", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["number"], name: "index_spree_imports_on_number", unique: true
    t.index ["owner_type", "owner_id"], name: "index_spree_imports_on_owner"
    t.index ["status"], name: "index_spree_imports_on_status"
    t.index ["type"], name: "index_spree_imports_on_type"
    t.index ["user_id"], name: "index_spree_imports_on_user_id"
  end

  create_table "spree_integrations", force: :cascade do |t|
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.text "preferences"
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_spree_integrations_on_active"
    t.index ["store_id", "type"], name: "index_spree_integrations_on_store_id_and_type", unique: true
    t.index ["store_id"], name: "index_spree_integrations_on_store_id"
    t.index ["type"], name: "index_spree_integrations_on_type"
  end

  create_table "spree_invitations", force: :cascade do |t|
    t.datetime "accepted_at"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "email", null: false
    t.datetime "expires_at"
    t.bigint "invitee_id"
    t.string "invitee_type"
    t.bigint "inviter_id", null: false
    t.string "inviter_type", null: false
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.bigint "role_id", null: false
    t.string "status", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_invitations_on_deleted_at"
    t.index ["email"], name: "index_spree_invitations_on_email"
    t.index ["expires_at"], name: "index_spree_invitations_on_expires_at"
    t.index ["invitee_type", "invitee_id"], name: "index_spree_invitations_on_invitee"
    t.index ["inviter_type", "inviter_id"], name: "index_spree_invitations_on_inviter"
    t.index ["resource_type", "resource_id"], name: "index_spree_invitations_on_resource"
    t.index ["role_id"], name: "index_spree_invitations_on_role_id"
    t.index ["status"], name: "index_spree_invitations_on_status"
    t.index ["token"], name: "index_spree_invitations_on_token", unique: true
  end

  create_table "spree_line_items", force: :cascade do |t|
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "cart_id"
    t.decimal "cost_price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.string "currency"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.jsonb "metadata"
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "order_id"
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.bigint "price_list_id"
    t.string "price_source"
    t.decimal "promo_total", precision: 10, scale: 2, default: "0.0"
    t.integer "quantity", null: false
    t.bigint "seller_id"
    t.bigint "tax_category_id"
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["cart_id"], name: "index_spree_line_items_on_cart_id"
    t.index ["order_id"], name: "index_spree_line_items_on_order_id"
    t.index ["price_list_id"], name: "index_spree_line_items_on_price_list_id"
    t.index ["seller_id"], name: "index_spree_line_items_on_seller_id"
    t.index ["tax_category_id"], name: "index_spree_line_items_on_tax_category_id"
    t.index ["variant_id"], name: "index_spree_line_items_on_variant_id"
  end

  create_table "spree_log_entries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "details"
    t.bigint "source_id"
    t.string "source_type"
    t.datetime "updated_at", null: false
    t.index ["source_id", "source_type"], name: "index_spree_log_entries_on_source_id_and_source_type"
  end

  create_table "spree_market_countries", force: :cascade do |t|
    t.string "country_code"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.bigint "market_id", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_spree_market_countries_on_country_id"
    t.index ["market_id", "country_code"], name: "index_spree_market_countries_on_market_id_and_country_code", unique: true
    t.index ["market_id", "country_id"], name: "index_spree_market_countries_on_market_id_and_country_id", unique: true
    t.index ["market_id"], name: "index_spree_market_countries_on_market_id"
  end

  create_table "spree_markets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.boolean "default", default: false, null: false
    t.string "default_locale", null: false
    t.datetime "deleted_at"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.bigint "store_id", null: false
    t.string "supported_locales"
    t.boolean "tax_inclusive", default: false, null: false
    t.string "tax_provider"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_markets_on_deleted_at"
    t.index ["store_id", "default"], name: "index_spree_markets_on_store_id_and_default", where: "(deleted_at IS NULL)"
    t.index ["store_id", "name"], name: "index_spree_markets_on_store_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id", "position"], name: "index_spree_markets_on_store_id_and_position"
    t.index ["store_id"], name: "index_spree_markets_on_store_id"
  end

  create_table "spree_media", force: :cascade do |t|
    t.text "alt"
    t.string "attachment_content_type"
    t.string "attachment_file_name"
    t.integer "attachment_file_size"
    t.integer "attachment_height"
    t.datetime "attachment_updated_at", precision: nil
    t.integer "attachment_width"
    t.datetime "created_at", precision: nil
    t.string "external_video_url"
    t.decimal "focal_point_x", precision: 5, scale: 4
    t.decimal "focal_point_y", precision: 5, scale: 4
    t.string "media_type"
    t.jsonb "metadata"
    t.integer "position"
    t.string "session_id"
    t.bigint "store_id"
    t.string "type", limit: 75
    t.datetime "updated_at", precision: nil
    t.bigint "viewable_id"
    t.string "viewable_type"
    t.index ["media_type"], name: "index_spree_media_on_media_type"
    t.index ["position"], name: "index_spree_media_on_position"
    t.index ["store_id"], name: "index_spree_media_on_store_id"
    t.index ["viewable_id"], name: "index_assets_on_viewable_id"
    t.index ["viewable_type", "type"], name: "index_assets_on_viewable_type_and_type"
  end

  create_table "spree_newsletter_subscribers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "email", null: false
    t.jsonb "metadata"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.string "verification_token"
    t.datetime "verified_at"
    t.index ["customer_id"], name: "index_spree_newsletter_subscribers_on_customer_id"
    t.index ["email", "store_id"], name: "index_spree_newsletter_subscribers_on_email_and_store_id", unique: true
    t.index ["store_id"], name: "index_spree_newsletter_subscribers_on_store_id"
    t.index ["verification_token"], name: "index_spree_newsletter_subscribers_on_verification_token", unique: true
    t.index ["verified_at"], name: "index_spree_newsletter_subscribers_on_verified_at"
  end

  create_table "spree_number_sequences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "resource_type", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "value", default: 0, null: false
    t.index ["store_id", "resource_type"], name: "index_spree_number_sequences_on_store_and_resource", unique: true
    t.index ["store_id"], name: "index_spree_number_sequences_on_store_id"
  end

  create_table "spree_option_type_product_types", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "option_type_id"
    t.bigint "product_type_id"
    t.datetime "updated_at", precision: nil
    t.index ["option_type_id"], name: "index_option_type_product_types_on_option_type_id"
    t.index ["product_type_id", "option_type_id"], name: "index_option_type_product_types_uniqueness", unique: true
  end

  create_table "spree_option_type_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "presentation"
    t.bigint "spree_option_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_option_type_translations_on_locale"
    t.index ["spree_option_type_id", "locale"], name: "unique_option_type_id_per_locale", unique: true
  end

  create_table "spree_option_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "filterable", default: true, null: false
    t.string "kind", default: "dropdown", null: false
    t.jsonb "metadata"
    t.string "name", limit: 100
    t.integer "position", default: 0, null: false
    t.string "presentation", limit: 100
    t.datetime "updated_at", null: false
    t.index ["filterable"], name: "index_spree_option_types_on_filterable"
    t.index ["kind"], name: "index_spree_option_types_on_kind"
    t.index ["name"], name: "index_spree_option_types_on_name", unique: true
    t.index ["position"], name: "index_spree_option_types_on_position"
  end

  create_table "spree_option_value_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "presentation"
    t.bigint "spree_option_value_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_option_value_translations_on_locale"
    t.index ["spree_option_value_id", "locale"], name: "unique_option_value_id_per_locale", unique: true
  end

  create_table "spree_option_value_variants", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "option_value_id"
    t.datetime "updated_at", precision: nil
    t.bigint "variant_id"
    t.index ["option_value_id"], name: "index_spree_option_value_variants_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_option_values_variants_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_spree_option_value_variants_on_variant_id"
  end

  create_table "spree_option_values", force: :cascade do |t|
    t.string "color_code"
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name"
    t.bigint "option_type_id"
    t.integer "position"
    t.string "presentation"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_spree_option_values_on_name"
    t.index ["option_type_id", "name"], name: "index_spree_option_values_on_option_type_id_and_name", unique: true
    t.index ["option_type_id"], name: "index_spree_option_values_on_option_type_id"
    t.index ["position"], name: "index_spree_option_values_on_position"
  end

  create_table "spree_order_approvals", force: :cascade do |t|
    t.bigint "approver_id"
    t.string "approver_type"
    t.datetime "created_at", null: false
    t.datetime "decided_at"
    t.string "level"
    t.jsonb "metadata"
    t.text "note"
    t.bigint "order_id", null: false
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.index ["approver_id", "approver_type"], name: "idx_order_approvals_approver"
    t.index ["order_id", "status"], name: "index_spree_order_approvals_on_order_id_and_status"
  end

  create_table "spree_order_cancellations", force: :cascade do |t|
    t.bigint "canceled_by_id"
    t.string "canceled_by_type"
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.text "note"
    t.boolean "notify_customer", null: false
    t.bigint "order_id", null: false
    t.string "reason", null: false
    t.decimal "refund_amount", precision: 10, scale: 2
    t.boolean "refund_payments", null: false
    t.boolean "restock_items", null: false
    t.datetime "updated_at", null: false
    t.index ["canceled_by_id", "canceled_by_type"], name: "idx_order_cancellations_canceled_by"
    t.index ["created_at"], name: "index_spree_order_cancellations_on_created_at"
    t.index ["order_id"], name: "index_spree_order_cancellations_on_order_id"
  end

  create_table "spree_order_groups", force: :cascade do |t|
    t.bigint "bill_address_id"
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "customer_id"
    t.string "email"
    t.jsonb "metadata"
    t.string "number", null: false
    t.bigint "ship_address_id"
    t.bigint "store_id", null: false
    t.string "token"
    t.datetime "updated_at", null: false
    t.index ["bill_address_id"], name: "index_spree_order_groups_on_bill_address_id"
    t.index ["cart_id"], name: "index_spree_order_groups_on_cart_id", unique: true
    t.index ["customer_id"], name: "index_spree_order_groups_on_customer_id"
    t.index ["number"], name: "index_spree_order_groups_on_number", unique: true
    t.index ["ship_address_id"], name: "index_spree_order_groups_on_ship_address_id"
    t.index ["store_id", "created_at"], name: "index_spree_order_groups_on_store_id_and_created_at"
    t.index ["store_id"], name: "index_spree_order_groups_on_store_id"
    t.index ["token"], name: "index_spree_order_groups_on_token"
  end

  create_table "spree_order_promotions", force: :cascade do |t|
    t.bigint "cart_id"
    t.datetime "created_at", precision: nil
    t.bigint "order_id"
    t.bigint "promotion_id"
    t.datetime "updated_at", precision: nil
    t.index ["cart_id"], name: "index_spree_order_promotions_on_cart_id"
    t.index ["order_id"], name: "index_spree_order_promotions_on_order_id"
    t.index ["promotion_id", "order_id"], name: "index_spree_order_promotions_on_promotion_id_and_order_id", unique: true
    t.index ["promotion_id"], name: "index_spree_order_promotions_on_promotion_id"
  end

  create_table "spree_order_routing_rules", force: :cascade do |t|
    t.boolean "active", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.integer "position", null: false
    t.text "preferences"
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id", "active", "position"], name: "idx_order_routing_rules_lookup"
    t.index ["channel_id", "position"], name: "index_spree_order_routing_rules_on_channel_id_and_position"
    t.index ["channel_id", "type"], name: "idx_order_routing_rules_channel_type", unique: true
    t.index ["channel_id"], name: "index_spree_order_routing_rules_on_channel_id"
    t.index ["store_id"], name: "index_spree_order_routing_rules_on_store_id"
    t.index ["type"], name: "index_spree_order_routing_rules_on_type"
  end

  create_table "spree_orders", force: :cascade do |t|
    t.boolean "accept_marketing", default: false
    t.decimal "additional_tax_total", precision: 10, scale: 2, default: "0.0"
    t.decimal "adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "approved_at", precision: nil
    t.bigint "approver_id"
    t.bigint "bill_address_id"
    t.datetime "canceled_at", precision: nil
    t.bigint "canceler_id"
    t.bigint "cart_id"
    t.string "channel", default: "spree"
    t.bigint "channel_id"
    t.bigint "company_id"
    t.datetime "completed_at", precision: nil
    t.boolean "confirmation_delivered", default: false
    t.boolean "considered_risky", default: false
    t.string "coupon_code"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency"
    t.bigint "customer_id"
    t.text "customer_note"
    t.decimal "delivery_total", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "discount_total", precision: 10, scale: 2, default: "0.0"
    t.string "email"
    t.decimal "fee_total", precision: 10, scale: 2
    t.string "fulfillment_status"
    t.bigint "gift_card_id"
    t.decimal "included_tax_total", precision: 10, scale: 2, default: "0.0", null: false
    t.text "internal_note"
    t.decimal "item_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "last_ip_address"
    t.string "locale"
    t.integer "lock_version", default: 0, null: false
    t.bigint "market_id"
    t.jsonb "metadata"
    t.decimal "non_taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "number", limit: 32
    t.bigint "order_group_id"
    t.string "payment_status"
    t.decimal "payment_total", precision: 10, scale: 2, default: "0.0"
    t.bigint "preferred_stock_location_id"
    t.bigint "seller_id"
    t.bigint "ship_address_id"
    t.boolean "signup_for_an_account", default: false
    t.string "status", default: "draft", null: false
    t.bigint "store_id"
    t.boolean "store_owner_notification_delivered"
    t.decimal "taxable_adjustment_total", precision: 10, scale: 2, default: "0.0", null: false
    t.string "token"
    t.decimal "total", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "total_quantity", default: 0
    t.datetime "updated_at", null: false
    t.index ["approver_id"], name: "index_spree_orders_on_approver_id"
    t.index ["bill_address_id"], name: "index_spree_orders_on_bill_address_id"
    t.index ["canceler_id"], name: "index_spree_orders_on_canceler_id"
    t.index ["cart_id"], name: "index_spree_orders_on_cart_id", unique: true
    t.index ["channel_id"], name: "index_spree_orders_on_channel_id"
    t.index ["company_id"], name: "index_spree_orders_on_company_id"
    t.index ["completed_at"], name: "index_spree_orders_on_completed_at"
    t.index ["confirmation_delivered"], name: "index_spree_orders_on_confirmation_delivered"
    t.index ["considered_risky"], name: "index_spree_orders_on_considered_risky"
    t.index ["coupon_code"], name: "index_spree_orders_on_coupon_code"
    t.index ["created_by_id"], name: "index_spree_orders_on_created_by_id"
    t.index ["customer_id", "created_by_id"], name: "index_spree_orders_on_customer_id_and_created_by_id"
    t.index ["fulfillment_status"], name: "index_spree_orders_on_fulfillment_status"
    t.index ["gift_card_id"], name: "index_spree_orders_on_gift_card_id"
    t.index ["market_id"], name: "index_spree_orders_on_market_id"
    t.index ["number"], name: "index_spree_orders_on_number", unique: true
    t.index ["order_group_id"], name: "index_spree_orders_on_order_group_id"
    t.index ["payment_status"], name: "index_spree_orders_on_payment_status"
    t.index ["preferred_stock_location_id"], name: "index_spree_orders_on_preferred_stock_location_id"
    t.index ["seller_id"], name: "index_spree_orders_on_seller_id"
    t.index ["ship_address_id"], name: "index_spree_orders_on_ship_address_id"
    t.index ["status"], name: "index_spree_orders_on_status"
    t.index ["store_id"], name: "index_spree_orders_on_store_id"
    t.index ["token"], name: "index_spree_orders_on_token"
  end

  create_table "spree_payment_capture_events", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.bigint "payment_id"
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_spree_payment_capture_events_on_payment_id"
  end

  create_table "spree_payment_methods", force: :cascade do |t|
    t.boolean "active", default: true
    t.boolean "auto_capture"
    t.string "capture_method"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.jsonb "metadata"
    t.string "name"
    t.integer "position", default: 0
    t.text "preferences"
    t.jsonb "settings"
    t.bigint "store_id"
    t.boolean "storefront_visible", default: true, null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["id", "type"], name: "index_spree_payment_methods_on_id_and_type"
    t.index ["store_id"], name: "index_spree_payment_methods_on_store_id"
  end

  create_table "spree_payment_methods_stores", id: false, force: :cascade do |t|
    t.bigint "payment_method_id"
    t.bigint "store_id"
    t.index ["payment_method_id", "store_id"], name: "payment_mentod_id_store_id_unique_index", unique: true
    t.index ["payment_method_id"], name: "index_spree_payment_methods_stores_on_payment_method_id"
    t.index ["store_id"], name: "index_spree_payment_methods_stores_on_store_id"
  end

  create_table "spree_payment_sessions", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.string "customer_external_id"
    t.bigint "customer_id"
    t.datetime "deleted_at"
    t.datetime "expires_at"
    t.jsonb "external_data"
    t.string "external_id", null: false
    t.bigint "order_id"
    t.bigint "payment_method_id", null: false
    t.string "status", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_payment_sessions_on_cart_id"
    t.index ["customer_id"], name: "index_spree_payment_sessions_on_customer_id"
    t.index ["deleted_at"], name: "index_spree_payment_sessions_on_deleted_at"
    t.index ["expires_at"], name: "index_spree_payment_sessions_on_expires_at"
    t.index ["external_id"], name: "index_spree_payment_sessions_on_external_id"
    t.index ["order_id", "payment_method_id", "external_id"], name: "idx_payment_sessions_order_method_external", unique: true
    t.index ["order_id"], name: "index_spree_payment_sessions_on_order_id"
    t.index ["payment_method_id"], name: "index_spree_payment_sessions_on_payment_method_id"
    t.index ["status"], name: "index_spree_payment_sessions_on_status"
    t.index ["type"], name: "index_spree_payment_sessions_on_type"
  end

  create_table "spree_payment_setup_sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.datetime "deleted_at"
    t.string "external_client_secret"
    t.jsonb "external_data"
    t.string "external_id"
    t.bigint "payment_method_id", null: false
    t.bigint "payment_source_id"
    t.string "payment_source_type"
    t.string "status", null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_spree_payment_setup_sessions_on_customer_id"
    t.index ["deleted_at"], name: "index_spree_payment_setup_sessions_on_deleted_at"
    t.index ["external_id", "payment_method_id"], name: "idx_spree_pss_unique_external_id_per_pm", unique: true
    t.index ["payment_method_id"], name: "index_spree_payment_setup_sessions_on_payment_method_id"
    t.index ["payment_source_type", "payment_source_id"], name: "idx_spree_pss_on_payment_source"
    t.index ["status"], name: "index_spree_payment_setup_sessions_on_status"
    t.index ["type"], name: "index_spree_payment_setup_sessions_on_type"
  end

  create_table "spree_payment_sources", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "customer_id"
    t.string "gateway_customer_profile_id"
    t.string "gateway_payment_profile_id"
    t.jsonb "metadata"
    t.bigint "payment_method_id"
    t.string "type"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id"], name: "index_spree_payment_sources_on_customer_id"
    t.index ["payment_method_id"], name: "index_spree_payment_sources_on_payment_method_id"
    t.index ["type", "gateway_payment_profile_id"], name: "index_payment_sources_on_type_and_gateway_payment_profile_id", unique: true
    t.index ["type"], name: "index_spree_payment_sources_on_type"
  end

  create_table "spree_payment_splits", force: :cascade do |t|
    t.decimal "authorized_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "captured_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.decimal "claimed_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "order_id", null: false
    t.bigint "payment_id", null: false
    t.decimal "refunded_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_spree_payment_splits_on_order_id"
    t.index ["payment_id", "order_id"], name: "index_spree_payment_splits_on_payment_id_and_order_id", unique: true
  end

  create_table "spree_payments", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "avs_response"
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.string "cvv_response_code"
    t.string "cvv_response_message"
    t.jsonb "metadata"
    t.string "number"
    t.bigint "order_group_id"
    t.bigint "order_id"
    t.bigint "payment_method_id"
    t.string "response_code"
    t.bigint "source_id"
    t.string "source_type"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_payments_on_cart_id"
    t.index ["number"], name: "index_spree_payments_on_number", unique: true
    t.index ["order_group_id"], name: "index_spree_payments_on_order_group_id"
    t.index ["order_id", "payment_method_id", "response_code"], name: "idx_payments_order_method_response_code", unique: true, where: "(response_code IS NOT NULL)"
    t.index ["order_id"], name: "index_spree_payments_on_order_id"
    t.index ["payment_method_id"], name: "index_spree_payments_on_payment_method_id"
    t.index ["source_id", "source_type"], name: "index_spree_payments_on_source_id_and_source_type"
  end

  create_table "spree_paypal_checkout_orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.jsonb "data"
    t.bigint "order_id", null: false
    t.bigint "payment_method_id", null: false
    t.string "paypal_id", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "paypal_id"], name: "index_spree_paypal_checkout_orders_on_order_id_and_paypal_id", unique: true
    t.index ["order_id"], name: "index_spree_paypal_checkout_orders_on_order_id"
    t.index ["payment_method_id"], name: "index_spree_paypal_checkout_orders_on_payment_method_id"
  end

  create_table "spree_policies", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "owner_id"
    t.string "owner_type"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type", "slug"], name: "index_spree_policies_on_owner_id_and_owner_type_and_slug", unique: true
    t.index ["owner_type", "owner_id"], name: "index_spree_policies_on_owner"
  end

  create_table "spree_policy_translations", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "name"
    t.bigint "spree_policy_id", null: false
    t.datetime "updated_at", null: false
    t.index ["spree_policy_id", "locale"], name: "index_spree_policy_translations_on_spree_policy_id_and_locale", unique: true
    t.index ["spree_policy_id"], name: "index_spree_policy_translations_on_spree_policy_id"
  end

  create_table "spree_preferences", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key"
    t.datetime "updated_at", null: false
    t.text "value"
    t.index ["key"], name: "index_spree_preferences_on_key", unique: true
  end

  create_table "spree_price_histories", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.decimal "compare_at_amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.bigint "price_id", null: false
    t.datetime "recorded_at", null: false
    t.bigint "variant_id", null: false
    t.index ["price_id", "recorded_at"], name: "idx_price_histories_price_recorded"
    t.index ["recorded_at"], name: "idx_price_histories_recorded_at"
    t.index ["variant_id", "currency", "recorded_at"], name: "idx_price_histories_variant_currency_recorded"
  end

  create_table "spree_price_lists", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.text "description"
    t.datetime "ends_at"
    t.string "match_policy", default: "all", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "starts_at"
    t.string "status", default: "draft", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_price_lists_on_deleted_at"
    t.index ["position"], name: "index_spree_price_lists_on_position"
    t.index ["starts_at", "ends_at"], name: "index_spree_price_lists_on_starts_at_and_ends_at"
    t.index ["status"], name: "index_spree_price_lists_on_status"
    t.index ["store_id", "status", "position"], name: "index_spree_price_lists_on_store_id_and_status_and_position"
    t.index ["store_id"], name: "index_spree_price_lists_on_store_id"
  end

  create_table "spree_price_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "preferences"
    t.bigint "price_list_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["price_list_id", "type"], name: "index_spree_price_rules_on_price_list_id_and_type", unique: true
    t.index ["price_list_id"], name: "index_spree_price_rules_on_price_list_id"
    t.index ["type"], name: "index_spree_price_rules_on_type"
  end

  create_table "spree_prices", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "compare_at_amount", precision: 10, scale: 2
    t.datetime "created_at", precision: nil, null: false
    t.string "currency"
    t.datetime "deleted_at", precision: nil
    t.bigint "price_list_id"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "variant_id", null: false
    t.index ["deleted_at"], name: "index_spree_prices_on_deleted_at"
    t.index ["price_list_id"], name: "index_spree_prices_on_price_list_id"
    t.index ["variant_id", "currency", "price_list_id"], name: "index_spree_prices_on_variant_currency_price_list", unique: true, where: "((price_list_id IS NOT NULL) AND (deleted_at IS NULL) AND (amount IS NOT NULL))"
    t.index ["variant_id", "currency"], name: "index_spree_prices_on_variant_id_and_currency", unique: true, where: "((price_list_id IS NULL) AND (deleted_at IS NULL) AND (amount IS NOT NULL))"
    t.index ["variant_id"], name: "index_spree_prices_on_variant_id"
  end

  create_table "spree_product_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: nil
    t.integer "position"
    t.bigint "product_id"
    t.datetime "updated_at", precision: nil
    t.index ["category_id"], name: "index_spree_product_categories_on_category_id"
    t.index ["position"], name: "index_spree_product_categories_on_position"
    t.index ["product_id", "category_id"], name: "index_spree_product_categories_on_product_id_and_category_id", unique: true
    t.index ["product_id"], name: "index_spree_product_categories_on_product_id"
  end

  create_table "spree_product_collections", force: :cascade do |t|
    t.bigint "collection_id", null: false
    t.datetime "created_at", null: false
    t.integer "position"
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id", "product_id"], name: "index_product_collections_on_collection_and_product", unique: true
    t.index ["collection_id"], name: "index_spree_product_collections_on_collection_id"
    t.index ["product_id"], name: "index_spree_product_collections_on_product_id"
  end

  create_table "spree_product_option_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "option_type_id"
    t.integer "position"
    t.bigint "product_id"
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_spree_product_option_types_on_option_type_id"
    t.index ["position"], name: "index_spree_product_option_types_on_position"
    t.index ["product_id"], name: "index_spree_product_option_types_on_product_id"
  end

  create_table "spree_product_promotion_rules", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "product_id"
    t.bigint "promotion_rule_id"
    t.datetime "updated_at", precision: nil
    t.index ["product_id", "promotion_rule_id"], name: "idx_on_product_id_promotion_rule_id_aaea0385c9", unique: true
    t.index ["product_id"], name: "index_products_promotion_rules_on_product_id"
    t.index ["promotion_rule_id", "product_id"], name: "index_products_promotion_rules_on_promotion_rule_and_product"
  end

  create_table "spree_product_publications", force: :cascade do |t|
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.bigint "product_id", null: false
    t.datetime "published_at"
    t.datetime "unpublished_at"
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_spree_product_publications_on_channel_id"
    t.index ["product_id", "channel_id"], name: "index_spree_product_publications_on_product_and_channel", unique: true
    t.index ["product_id"], name: "index_spree_product_publications_on_product_id"
  end

  create_table "spree_product_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.string "locale", null: false
    t.text "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.string "name"
    t.string "slug"
    t.bigint "spree_product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_product_translations_on_deleted_at"
    t.index ["locale", "slug"], name: "unique_slug_per_locale", unique: true
    t.index ["locale"], name: "index_spree_product_translations_on_locale"
    t.index ["spree_product_id", "locale"], name: "unique_product_id_per_locale", unique: true
  end

  create_table "spree_product_type_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: nil
    t.bigint "product_type_id"
    t.datetime "updated_at", precision: nil
    t.index ["category_id"], name: "index_product_type_categories_on_category_id"
    t.index ["product_type_id", "category_id"], name: "index_product_type_categories_uniqueness", unique: true
  end

  create_table "spree_product_type_custom_field_definitions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "custom_field_definition_id", null: false
    t.bigint "product_type_id", null: false
    t.boolean "required", default: false, null: false
    t.integer "sort_order", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_definition_id"], name: "idx_on_custom_field_definition_id_8b23a96514"
    t.index ["product_type_id", "custom_field_definition_id"], name: "idx_product_type_cf_defs_unique", unique: true
  end

  create_table "spree_product_type_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "name"
    t.bigint "spree_product_type_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_product_type_translations_on_locale"
    t.index ["spree_product_type_id", "locale"], name: "index_product_type_translations_on_product_type_and_locale", unique: true
  end

  create_table "spree_product_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "delivery_profile_id"
    t.jsonb "metadata"
    t.string "name"
    t.integer "products_count", default: 0, null: false
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.index ["delivery_profile_id"], name: "index_spree_product_types_on_delivery_profile_id"
    t.index ["store_id"], name: "index_spree_product_types_on_store_id"
  end

  create_table "spree_products", force: :cascade do |t|
    t.datetime "available_on", precision: nil
    t.integer "categories_count", default: 0, null: false
    t.integer "collections_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.bigint "default_variant_id"
    t.datetime "deleted_at", precision: nil
    t.bigint "delivery_profile_id"
    t.text "description"
    t.datetime "discontinue_on", precision: nil
    t.datetime "make_active_at", precision: nil
    t.integer "media_count", default: 0, null: false
    t.text "meta_description"
    t.string "meta_keywords"
    t.string "meta_title"
    t.jsonb "metadata"
    t.string "name", default: "", null: false
    t.bigint "primary_media_id"
    t.bigint "product_type_id"
    t.boolean "promotionable", default: true
    t.decimal "revenue", precision: 16, scale: 4, default: "0.0", null: false
    t.bigint "seller_id"
    t.string "slug"
    t.string "status", default: "draft", null: false
    t.bigint "store_id"
    t.bigint "tax_category_id"
    t.integer "units_sold_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "variant_count", default: 0, null: false
    t.index ["available_on"], name: "index_spree_products_on_available_on"
    t.index ["categories_count"], name: "index_spree_products_on_categories_count"
    t.index ["default_variant_id"], name: "index_spree_products_on_default_variant_id"
    t.index ["deleted_at"], name: "index_spree_products_on_deleted_at"
    t.index ["delivery_profile_id"], name: "index_spree_products_on_delivery_profile_id"
    t.index ["discontinue_on"], name: "index_spree_products_on_discontinue_on"
    t.index ["make_active_at"], name: "index_spree_products_on_make_active_at"
    t.index ["media_count"], name: "index_spree_products_on_media_count"
    t.index ["name"], name: "index_spree_products_on_name"
    t.index ["primary_media_id"], name: "index_spree_products_on_primary_media_id"
    t.index ["product_type_id"], name: "index_spree_products_on_product_type_id"
    t.index ["promotionable"], name: "index_spree_products_on_promotionable"
    t.index ["seller_id"], name: "index_spree_products_on_seller_id"
    t.index ["slug"], name: "index_spree_products_on_slug", unique: true
    t.index ["status", "deleted_at"], name: "index_spree_products_on_status_and_deleted_at"
    t.index ["status"], name: "index_spree_products_on_status"
    t.index ["store_id", "units_sold_count"], name: "index_spree_products_on_store_id_and_units_sold_count"
    t.index ["store_id"], name: "index_spree_products_on_store_id"
    t.index ["tax_category_id"], name: "index_spree_products_on_tax_category_id"
    t.index ["variant_count"], name: "index_spree_products_on_variant_count"
  end

  create_table "spree_products_stores", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "product_id"
    t.decimal "revenue", precision: 10, scale: 2, default: "0.0", null: false
    t.bigint "store_id"
    t.integer "units_sold_count", default: 0, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["product_id", "store_id"], name: "index_spree_products_stores_on_product_id_and_store_id", unique: true
    t.index ["product_id"], name: "index_spree_products_stores_on_product_id"
    t.index ["store_id", "revenue"], name: "index_products_stores_on_store_and_revenue"
    t.index ["store_id", "units_sold_count"], name: "index_products_stores_on_store_and_units_sold"
    t.index ["store_id"], name: "index_spree_products_stores_on_store_id"
  end

  create_table "spree_promotion_action_line_items", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "promotion_action_id"
    t.integer "quantity", default: 1
    t.datetime "updated_at", precision: nil
    t.bigint "variant_id"
    t.index ["promotion_action_id", "variant_id"], name: "idx_on_promotion_action_id_variant_id_90d181a88a", unique: true
    t.index ["promotion_action_id"], name: "index_spree_promotion_action_line_items_on_promotion_action_id"
    t.index ["variant_id"], name: "index_spree_promotion_action_line_items_on_variant_id"
  end

  create_table "spree_promotion_actions", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "deleted_at", precision: nil
    t.integer "position"
    t.bigint "promotion_id"
    t.string "type"
    t.datetime "updated_at", precision: nil
    t.index ["deleted_at"], name: "index_spree_promotion_actions_on_deleted_at"
    t.index ["id", "type"], name: "index_spree_promotion_actions_on_id_and_type"
    t.index ["promotion_id"], name: "index_spree_promotion_actions_on_promotion_id"
  end

  create_table "spree_promotion_categories", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "spree_promotion_rule_categories", force: :cascade do |t|
    t.bigint "category_id"
    t.datetime "created_at", precision: nil
    t.bigint "promotion_rule_id"
    t.datetime "updated_at", precision: nil
    t.index ["category_id", "promotion_rule_id"], name: "idx_on_category_id_promotion_rule_id_530c96f872", unique: true
    t.index ["category_id"], name: "index_spree_promotion_rule_categories_on_category_id"
    t.index ["promotion_rule_id"], name: "index_spree_promotion_rule_categories_on_promotion_rule_id"
  end

  create_table "spree_promotion_rule_users", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "customer_id"
    t.bigint "promotion_rule_id"
    t.datetime "updated_at", precision: nil
    t.index ["customer_id", "promotion_rule_id"], name: "idx_on_customer_id_promotion_rule_id_90bd732c00", unique: true
    t.index ["customer_id", "promotion_rule_id"], name: "index_promotion_rules_users_on_user_id_and_promotion_rule_id"
    t.index ["promotion_rule_id"], name: "index_promotion_rules_users_on_promotion_rule_id"
  end

  create_table "spree_promotion_rules", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.text "preferences"
    t.bigint "product_group_id"
    t.bigint "promotion_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["product_group_id"], name: "index_promotion_rules_on_product_group_id"
    t.index ["promotion_id", "type"], name: "index_spree_promotion_rules_on_promotion_id_and_type", unique: true
    t.index ["promotion_id"], name: "index_spree_promotion_rules_on_promotion_id"
    t.index ["user_id"], name: "index_promotion_rules_on_user_id"
  end

  create_table "spree_promotions", force: :cascade do |t|
    t.boolean "advertise", default: false
    t.string "code"
    t.string "code_prefix"
    t.datetime "created_at", null: false
    t.string "description"
    t.datetime "expires_at", precision: nil
    t.integer "kind", default: 0
    t.string "match_policy", default: "all"
    t.jsonb "metadata"
    t.boolean "multi_codes", default: false
    t.string "name"
    t.integer "number_of_codes"
    t.string "path"
    t.bigint "promotion_category_id"
    t.datetime "starts_at", precision: nil
    t.bigint "store_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.integer "usage_limit"
    t.index ["advertise"], name: "index_spree_promotions_on_advertise"
    t.index ["code"], name: "index_spree_promotions_on_code"
    t.index ["expires_at"], name: "index_spree_promotions_on_expires_at"
    t.index ["id", "type"], name: "index_spree_promotions_on_id_and_type"
    t.index ["kind"], name: "index_spree_promotions_on_kind"
    t.index ["path"], name: "index_spree_promotions_on_path"
    t.index ["promotion_category_id"], name: "index_spree_promotions_on_promotion_category_id"
    t.index ["starts_at"], name: "index_spree_promotions_on_starts_at"
    t.index ["store_id"], name: "index_spree_promotions_on_store_id"
  end

  create_table "spree_promotions_stores", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "promotion_id"
    t.bigint "store_id"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["promotion_id", "store_id"], name: "index_spree_promotions_stores_on_promotion_id_and_store_id", unique: true
    t.index ["promotion_id"], name: "index_spree_promotions_stores_on_promotion_id"
    t.index ["store_id"], name: "index_spree_promotions_stores_on_store_id"
  end

  create_table "spree_refresh_tokens", force: :cascade do |t|
    t.string "audience"
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "ip_address"
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.string "user_type", null: false
    t.index ["expires_at"], name: "index_spree_refresh_tokens_on_expires_at"
    t.index ["token"], name: "index_spree_refresh_tokens_on_token", unique: true
    t.index ["user_type", "user_id"], name: "idx_refresh_tokens_user"
    t.index ["user_type", "user_id"], name: "index_spree_refresh_tokens_on_user"
  end

  create_table "spree_refund_reasons", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "name"], name: "index_spree_refund_reasons_on_store_id_and_name", unique: true
    t.index ["store_id"], name: "index_spree_refund_reasons_on_store_id"
  end

  create_table "spree_refunds", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.bigint "order_id"
    t.bigint "originator_id"
    t.string "originator_type"
    t.bigint "payment_id"
    t.bigint "refund_reason_id"
    t.bigint "refunder_id"
    t.bigint "reimbursement_id"
    t.string "transaction_id"
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_spree_refunds_on_order_id"
    t.index ["originator_type", "originator_id"], name: "index_spree_refunds_on_originator"
    t.index ["payment_id"], name: "index_spree_refunds_on_payment_id"
    t.index ["refund_reason_id"], name: "index_refunds_on_refund_reason_id"
    t.index ["refunder_id"], name: "index_spree_refunds_on_refunder_id"
    t.index ["reimbursement_id"], name: "index_spree_refunds_on_reimbursement_id"
  end

  create_table "spree_reimbursement_credits", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", precision: nil
    t.bigint "creditable_id"
    t.string "creditable_type"
    t.bigint "reimbursement_id"
    t.datetime "updated_at", precision: nil
    t.index ["creditable_id", "creditable_type"], name: "index_reimbursement_credits_on_creditable_id_and_type"
    t.index ["reimbursement_id"], name: "index_spree_reimbursement_credits_on_reimbursement_id"
  end

  create_table "spree_reimbursement_types", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.boolean "mutable", default: true
    t.string "name"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_spree_reimbursement_types_on_name", unique: true
    t.index ["type"], name: "index_spree_reimbursement_types_on_type"
  end

  create_table "spree_reimbursements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "customer_return_id"
    t.string "number"
    t.bigint "order_id"
    t.bigint "performed_by_id"
    t.string "reimbursement_status"
    t.decimal "total", precision: 10, scale: 2
    t.datetime "updated_at", null: false
    t.index ["customer_return_id"], name: "index_spree_reimbursements_on_customer_return_id"
    t.index ["number"], name: "index_spree_reimbursements_on_number", unique: true
    t.index ["order_id"], name: "index_spree_reimbursements_on_order_id"
    t.index ["performed_by_id"], name: "index_spree_reimbursements_on_performed_by_id"
  end

  create_table "spree_reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency"
    t.datetime "date_from", precision: nil
    t.datetime "date_to", precision: nil
    t.bigint "store_id", null: false
    t.string "type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["store_id"], name: "index_spree_reports_on_store_id"
    t.index ["user_id"], name: "index_spree_reports_on_user_id"
  end

  create_table "spree_return_authorizations", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "memo"
    t.string "number"
    t.bigint "order_id"
    t.bigint "return_authorization_reason_id"
    t.string "state"
    t.bigint "stock_location_id"
    t.datetime "updated_at", precision: nil
    t.index ["number"], name: "index_spree_return_authorizations_on_number", unique: true
    t.index ["order_id"], name: "index_spree_return_authorizations_on_order_id"
    t.index ["return_authorization_reason_id"], name: "index_return_authorizations_on_return_authorization_reason_id"
    t.index ["stock_location_id"], name: "index_spree_return_authorizations_on_stock_location_id"
  end

  create_table "spree_return_items", force: :cascade do |t|
    t.string "acceptance_status"
    t.text "acceptance_status_errors"
    t.decimal "additional_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.bigint "customer_return_id"
    t.bigint "exchange_variant_id"
    t.bigint "fulfillment_item_id"
    t.decimal "included_tax_total", precision: 12, scale: 4, default: "0.0", null: false
    t.bigint "override_reimbursement_type_id"
    t.decimal "pre_tax_amount", precision: 12, scale: 4, default: "0.0", null: false
    t.bigint "preferred_reimbursement_type_id"
    t.string "reception_status"
    t.bigint "reimbursement_id"
    t.boolean "resellable", default: true, null: false
    t.bigint "return_authorization_id"
    t.datetime "updated_at", null: false
    t.index ["customer_return_id"], name: "index_return_items_on_customer_return_id"
    t.index ["exchange_variant_id"], name: "index_spree_return_items_on_exchange_variant_id"
    t.index ["fulfillment_item_id"], name: "index_spree_return_items_on_fulfillment_item_id"
    t.index ["override_reimbursement_type_id"], name: "index_spree_return_items_on_override_reimbursement_type_id"
    t.index ["preferred_reimbursement_type_id"], name: "index_spree_return_items_on_preferred_reimbursement_type_id"
    t.index ["reimbursement_id"], name: "index_spree_return_items_on_reimbursement_id"
    t.index ["return_authorization_id"], name: "index_spree_return_items_on_return_authorization_id"
  end

  create_table "spree_return_line_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "fulfillment_item_id", null: false
    t.bigint "line_item_id", null: false
    t.decimal "pre_tax_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.integer "quantity", default: 1, null: false
    t.integer "received_quantity", default: 0, null: false
    t.boolean "resellable", default: true, null: false
    t.bigint "return_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["fulfillment_item_id"], name: "index_spree_return_line_items_on_fulfillment_item_id"
    t.index ["line_item_id"], name: "index_spree_return_line_items_on_line_item_id"
    t.index ["return_id"], name: "index_spree_return_line_items_on_return_id"
    t.index ["variant_id"], name: "index_spree_return_line_items_on_variant_id"
  end

  create_table "spree_return_reasons", force: :cascade do |t|
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.string "name"
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "name"], name: "index_spree_return_reasons_on_store_id_and_name", unique: true
    t.index ["store_id"], name: "index_spree_return_reasons_on_store_id"
  end

  create_table "spree_returns", force: :cascade do |t|
    t.datetime "approved_at"
    t.datetime "canceled_at"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.text "memo"
    t.jsonb "metadata"
    t.string "number", null: false
    t.bigint "order_id", null: false
    t.bigint "reason_id"
    t.datetime "received_at"
    t.datetime "refunded_at"
    t.string "status", null: false
    t.bigint "stock_location_id", null: false
    t.bigint "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by_id"], name: "index_spree_returns_on_created_by_id"
    t.index ["number"], name: "index_spree_returns_on_number", unique: true
    t.index ["order_id"], name: "index_spree_returns_on_order_id"
    t.index ["reason_id"], name: "index_spree_returns_on_reason_id"
    t.index ["status"], name: "index_spree_returns_on_status"
    t.index ["stock_location_id"], name: "index_spree_returns_on_stock_location_id"
    t.index ["store_id"], name: "index_spree_returns_on_store_id"
  end

  create_table "spree_role_users", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.bigint "invitation_id"
    t.bigint "role_id"
    t.datetime "updated_at", precision: nil
    t.bigint "user_id"
    t.string "user_type", null: false
    t.index ["invitation_id"], name: "index_spree_role_users_on_invitation_id"
    t.index ["role_id"], name: "index_spree_role_users_on_role_id"
    t.index ["user_id"], name: "index_spree_role_users_on_user_id"
    t.index ["user_type", "user_id", "role_id"], name: "index_spree_role_users_on_user_and_role", unique: true
    t.index ["user_type"], name: "index_spree_role_users_on_user_type"
  end

  create_table "spree_roles", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "description"
    t.boolean "mutable", default: true, null: false
    t.string "name"
    t.jsonb "permissions"
    t.bigint "resource_id", null: false
    t.string "resource_type", null: false
    t.datetime "updated_at", precision: nil
    t.index ["resource_type", "resource_id", "name"], name: "index_spree_roles_on_resource_and_name", unique: true
  end

  create_table "spree_seller_requirement_custom_fields", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "custom_field_definition_id", null: false
    t.bigint "seller_requirement_id", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_field_definition_id"], name: "idx_on_custom_field_definition_id_7687001add"
    t.index ["seller_requirement_id", "custom_field_definition_id"], name: "idx_seller_requirement_custom_fields_uniqueness", unique: true
  end

  create_table "spree_seller_requirement_submissions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.text "note"
    t.string "reference"
    t.text "review_note"
    t.datetime "reviewed_at"
    t.bigint "reviewed_by_id"
    t.bigint "seller_id", null: false
    t.bigint "seller_requirement_id", null: false
    t.string "status", null: false
    t.bigint "submitted_by_id"
    t.datetime "updated_at", null: false
    t.index ["reviewed_by_id"], name: "index_spree_seller_requirement_submissions_on_reviewed_by_id"
    t.index ["seller_id", "seller_requirement_id", "created_at"], name: "index_seller_requirement_submissions_on_pair_and_date"
    t.index ["seller_id"], name: "index_spree_seller_requirement_submissions_on_seller_id"
    t.index ["seller_requirement_id"], name: "idx_on_seller_requirement_id_9d30ae5c62"
    t.index ["submitted_by_id"], name: "index_spree_seller_requirement_submissions_on_submitted_by_id"
  end

  create_table "spree_seller_requirements", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.jsonb "metadata"
    t.string "name"
    t.integer "position", default: 0, null: false
    t.text "preferences"
    t.boolean "required", default: true, null: false
    t.bigint "store_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id", "position"], name: "index_spree_seller_requirements_on_store_id_and_position"
    t.index ["store_id", "type"], name: "index_spree_seller_requirements_on_store_id_and_type"
    t.index ["store_id"], name: "index_spree_seller_requirements_on_store_id"
  end

  create_table "spree_seller_translations", force: :cascade do |t|
    t.text "about"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.string "locale", null: false
    t.string "name"
    t.bigint "spree_seller_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_seller_translations_on_locale"
    t.index ["spree_seller_id", "locale"], name: "index_seller_translations_on_seller_and_locale", unique: true
  end

  create_table "spree_sellers", force: :cascade do |t|
    t.text "about"
    t.bigint "billing_address_id"
    t.string "billing_email"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "holiday_mode_until"
    t.jsonb "metadata"
    t.decimal "minimum_payout_amount", precision: 10, scale: 2
    t.string "name", null: false
    t.string "payouts_schedule_interval"
    t.bigint "returns_address_id"
    t.string "slug", null: false
    t.string "status", null: false
    t.bigint "store_id", null: false
    t.string "tax_remittance", default: "seller", null: false
    t.datetime "terms_accepted_at"
    t.datetime "updated_at", null: false
    t.index ["billing_address_id"], name: "index_spree_sellers_on_billing_address_id"
    t.index ["deleted_at"], name: "index_spree_sellers_on_deleted_at"
    t.index ["returns_address_id"], name: "index_spree_sellers_on_returns_address_id"
    t.index ["store_id", "slug"], name: "index_spree_sellers_on_store_id_and_slug", unique: true
    t.index ["store_id", "status"], name: "index_spree_sellers_on_store_id_and_status"
    t.index ["store_id"], name: "index_spree_sellers_on_store_id"
  end

  create_table "spree_shipping_method_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "shipping_category_id", null: false
    t.bigint "shipping_method_id", null: false
    t.datetime "updated_at", null: false
    t.index ["shipping_category_id", "shipping_method_id"], name: "unique_spree_shipping_method_categories", unique: true
    t.index ["shipping_category_id"], name: "index_spree_shipping_method_categories_on_shipping_category_id"
    t.index ["shipping_method_id"], name: "index_spree_shipping_method_categories_on_shipping_method_id"
  end

  create_table "spree_state_changes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.string "next_state"
    t.string "previous_state"
    t.bigint "stateful_id"
    t.string "stateful_type"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["stateful_id", "stateful_type"], name: "index_spree_state_changes_on_stateful_id_and_stateful_type"
  end

  create_table "spree_states", force: :cascade do |t|
    t.string "abbr"
    t.bigint "country_id"
    t.datetime "created_at", precision: nil
    t.string "name"
    t.datetime "updated_at", precision: nil
    t.index ["country_id", "abbr"], name: "index_spree_states_on_country_id_and_abbr", unique: true
    t.index ["country_id"], name: "index_spree_states_on_country_id"
  end

  create_table "spree_stock_levels", force: :cascade do |t|
    t.integer "allocated_count", default: 0, null: false
    t.boolean "backorderable", default: false
    t.integer "count_on_hand", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.jsonb "metadata"
    t.bigint "stock_location_id"
    t.datetime "updated_at", null: false
    t.bigint "variant_id"
    t.index ["backorderable"], name: "index_spree_stock_levels_on_backorderable"
    t.index ["deleted_at"], name: "index_spree_stock_levels_on_deleted_at"
    t.index ["stock_location_id", "variant_id", "deleted_at"], name: "stock_level_by_loc_var_id_deleted_at", unique: true
    t.index ["stock_location_id", "variant_id"], name: "stock_level_by_loc_and_var_id"
    t.index ["stock_location_id"], name: "index_spree_stock_levels_on_stock_location_id"
    t.index ["variant_id", "stock_location_id"], name: "index_spree_stock_levels_unique_without_deleted_at", unique: true, where: "(deleted_at IS NULL)"
    t.index ["variant_id"], name: "index_spree_stock_levels_on_variant_id"
  end

  create_table "spree_stock_locations", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "address1"
    t.string "address2"
    t.string "admin_name"
    t.boolean "backorderable_default", default: false
    t.string "city"
    t.string "company"
    t.string "country_code"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.boolean "default", default: false, null: false
    t.datetime "deleted_at", precision: nil
    t.string "kind", default: "warehouse", null: false
    t.string "name"
    t.string "phone"
    t.boolean "pickup_enabled", default: false, null: false
    t.text "pickup_instructions"
    t.integer "pickup_ready_in_minutes"
    t.string "pickup_stock_policy", default: "local", null: false
    t.boolean "propagate_all_variants", default: false
    t.string "state_code"
    t.bigint "state_id"
    t.string "state_name"
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.string "zipcode"
    t.index ["active"], name: "index_spree_stock_locations_on_active"
    t.index ["backorderable_default"], name: "index_spree_stock_locations_on_backorderable_default"
    t.index ["country_id"], name: "index_spree_stock_locations_on_country_id"
    t.index ["deleted_at"], name: "index_spree_stock_locations_on_deleted_at"
    t.index ["kind"], name: "index_spree_stock_locations_on_kind"
    t.index ["pickup_enabled"], name: "index_spree_stock_locations_on_pickup_enabled"
    t.index ["propagate_all_variants"], name: "index_spree_stock_locations_on_propagate_all_variants"
    t.index ["state_id"], name: "index_spree_stock_locations_on_state_id"
    t.index ["store_id"], name: "index_spree_stock_locations_on_store_id"
  end

  create_table "spree_stock_movements", force: :cascade do |t|
    t.string "action"
    t.datetime "created_at", null: false
    t.bigint "exchange_id"
    t.bigint "fulfillment_id"
    t.string "kind"
    t.bigint "order_id"
    t.bigint "originator_id"
    t.string "originator_type"
    t.integer "quantity", default: 0
    t.string "reason"
    t.bigint "return_id"
    t.bigint "stock_level_id"
    t.bigint "stock_transfer_id"
    t.datetime "updated_at", null: false
    t.index ["exchange_id"], name: "index_spree_stock_movements_on_exchange_id"
    t.index ["fulfillment_id"], name: "index_spree_stock_movements_on_fulfillment_id"
    t.index ["kind"], name: "index_spree_stock_movements_on_kind"
    t.index ["order_id"], name: "index_spree_stock_movements_on_order_id"
    t.index ["originator_id", "originator_type"], name: "index_stock_movements_on_originator_id_and_originator_type"
    t.index ["return_id"], name: "index_spree_stock_movements_on_return_id"
    t.index ["stock_level_id"], name: "index_spree_stock_movements_on_stock_level_id"
    t.index ["stock_transfer_id"], name: "index_spree_stock_movements_on_stock_transfer_id"
  end

  create_table "spree_stock_reservations", force: :cascade do |t|
    t.bigint "cart_id"
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "line_item_id", null: false
    t.bigint "order_id"
    t.integer "quantity", null: false
    t.bigint "stock_level_id", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_stock_reservations_on_cart_id"
    t.index ["expires_at"], name: "index_spree_stock_reservations_on_expires_at"
    t.index ["line_item_id"], name: "index_spree_stock_reservations_on_line_item_id"
    t.index ["order_id"], name: "index_spree_stock_reservations_on_order_id"
    t.index ["stock_level_id", "expires_at"], name: "idx_on_stock_level_id_expires_at_e64b0c98f8"
    t.index ["stock_level_id", "line_item_id"], name: "idx_stock_reservations_level_line_item", unique: true
  end

  create_table "spree_stock_transfers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "destination_location_id"
    t.jsonb "metadata"
    t.string "number"
    t.string "reference"
    t.bigint "source_location_id"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["destination_location_id"], name: "index_spree_stock_transfers_on_destination_location_id"
    t.index ["number"], name: "index_spree_stock_transfers_on_number", unique: true
    t.index ["source_location_id"], name: "index_spree_stock_transfers_on_source_location_id"
  end

  create_table "spree_store_credit_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "spree_store_credit_events", force: :cascade do |t|
    t.string "action", null: false
    t.decimal "amount", precision: 8, scale: 2
    t.string "authorization_code", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.bigint "originator_id"
    t.string "originator_type"
    t.bigint "store_credit_id", null: false
    t.datetime "updated_at", null: false
    t.decimal "user_total_amount", precision: 8, scale: 2, default: "0.0", null: false
    t.index ["originator_id", "originator_type"], name: "spree_store_credit_events_originator"
    t.index ["store_credit_id"], name: "index_spree_store_credit_events_on_store_credit_id"
  end

  create_table "spree_store_credit_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "priority"
    t.datetime "updated_at", null: false
    t.index ["priority"], name: "index_spree_store_credit_types_on_priority"
  end

  create_table "spree_store_credits", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "amount_authorized", precision: 8, scale: 2, default: "0.0", null: false
    t.decimal "amount_used", precision: 8, scale: 2, default: "0.0", null: false
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.bigint "created_by_id"
    t.string "currency"
    t.bigint "customer_id"
    t.datetime "deleted_at", precision: nil
    t.text "memo"
    t.jsonb "metadata"
    t.bigint "originator_id"
    t.string "originator_type"
    t.bigint "store_id"
    t.bigint "type_id"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_spree_store_credits_on_customer_id"
    t.index ["deleted_at"], name: "index_spree_store_credits_on_deleted_at"
    t.index ["originator_id", "originator_type"], name: "spree_store_credits_originator"
    t.index ["store_id"], name: "index_spree_store_credits_on_store_id"
    t.index ["type_id"], name: "index_spree_store_credits_on_type_id"
  end

  create_table "spree_store_translations", force: :cascade do |t|
    t.text "address"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.string "customer_support_email"
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.string "facebook"
    t.string "instagram"
    t.string "locale", null: false
    t.text "meta_description"
    t.text "meta_keywords"
    t.string "name"
    t.string "new_order_notifications_email"
    t.string "seo_title"
    t.bigint "spree_store_id", null: false
    t.string "twitter"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_store_translations_on_deleted_at"
    t.index ["locale"], name: "index_spree_store_translations_on_locale"
    t.index ["spree_store_id", "locale"], name: "index_spree_store_translations_on_spree_store_id_locale", unique: true
  end

  create_table "spree_stores", force: :cascade do |t|
    t.text "address"
    t.bigint "checkout_zone_id"
    t.string "code"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.string "customer_support_email"
    t.boolean "default", default: false, null: false
    t.string "default_country_code"
    t.bigint "default_country_id"
    t.string "default_currency"
    t.string "default_locale"
    t.datetime "deleted_at", precision: nil
    t.text "description"
    t.string "facebook"
    t.string "instagram"
    t.string "mail_from_address"
    t.text "meta_description"
    t.text "meta_keywords"
    t.jsonb "metadata"
    t.string "name"
    t.string "new_order_notifications_email"
    t.text "preferences"
    t.string "seo_robots"
    t.string "seo_title"
    t.jsonb "settings"
    t.string "setup_token"
    t.text "storefront_custom_code_body_end"
    t.text "storefront_custom_code_body_start"
    t.text "storefront_custom_code_head"
    t.string "supported_currencies"
    t.string "supported_locales"
    t.string "twitter"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["code"], name: "index_spree_stores_on_code", unique: true
    t.index ["default"], name: "index_spree_stores_on_default"
    t.index ["deleted_at"], name: "index_spree_stores_on_deleted_at"
    t.index ["setup_token"], name: "index_spree_stores_on_setup_token", unique: true
    t.index ["url"], name: "index_spree_stores_on_url"
  end

  create_table "spree_stripe_payment_intents", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", null: false
    t.string "customer_id"
    t.string "ephemeral_key_secret"
    t.bigint "order_id", null: false
    t.bigint "payment_method_id", null: false
    t.string "stripe_id", null: false
    t.string "stripe_payment_method_id"
    t.datetime "updated_at", null: false
    t.index ["order_id", "stripe_id"], name: "index_spree_stripe_payment_intents_on_order_id_and_stripe_id", unique: true
    t.index ["order_id"], name: "index_spree_stripe_payment_intents_on_order_id"
    t.index ["payment_method_id"], name: "index_spree_stripe_payment_intents_on_payment_method_id"
  end

  create_table "spree_stripe_payment_methods_webhook_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "payment_method_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "webhook_key_id", null: false
    t.index ["payment_method_id", "webhook_key_id"], name: "index_payment_method_id_webhook_key_id_uniqueness", unique: true
    t.index ["payment_method_id"], name: "index_payment_methods_webhook_keys_on_payment_method_id"
    t.index ["webhook_key_id"], name: "index_payment_methods_webhook_keys_on_webhook_key_id"
  end

  create_table "spree_stripe_webhook_keys", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "signing_secret", null: false
    t.string "stripe_id", null: false
    t.datetime "updated_at", null: false
    t.index ["signing_secret"], name: "index_spree_stripe_webhook_keys_on_signing_secret", unique: true
    t.index ["stripe_id"], name: "index_spree_stripe_webhook_keys_on_stripe_id", unique: true
  end

  create_table "spree_taggings", force: :cascade do |t|
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.bigint "tag_id"
    t.bigint "taggable_id"
    t.string "taggable_type"
    t.bigint "tagger_id"
    t.string "tagger_type"
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_spree_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "spree_taggings_idx", unique: true
    t.index ["tag_id"], name: "index_spree_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "spree_taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "spree_taggings_idy"
    t.index ["taggable_id"], name: "index_spree_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_spree_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_spree_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_spree_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_spree_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_spree_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_spree_taggings_on_tenant"
  end

  create_table "spree_tags", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.integer "taggings_count", default: 0
    t.datetime "updated_at", null: false
    t.index "lower((name)::text) varchar_pattern_ops", name: "index_spree_tags_on_lower_name"
    t.index ["name"], name: "index_spree_tags_on_name", unique: true
  end

  create_table "spree_tax_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.string "description"
    t.boolean "is_default", default: false
    t.string "name"
    t.bigint "store_id"
    t.string "tax_code"
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_spree_tax_categories_on_deleted_at"
    t.index ["is_default"], name: "index_spree_tax_categories_on_is_default"
    t.index ["store_id", "name"], name: "index_spree_tax_categories_on_store_id_and_name", unique: true, where: "(deleted_at IS NULL)"
    t.index ["store_id"], name: "index_spree_tax_categories_on_store_id"
  end

  create_table "spree_tax_exemption_certificates", force: :cascade do |t|
    t.string "certificate_number", null: false
    t.bigint "company_id", null: false
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.datetime "issued_at"
    t.string "issuing_authority"
    t.jsonb "metadata"
    t.string "reason_code", null: false
    t.string "state_code"
    t.string "status", null: false
    t.datetime "updated_at", null: false
    t.datetime "verified_at"
    t.bigint "verified_by_id"
    t.index ["company_id", "status"], name: "idx_on_company_id_status_9f9c6d73b6"
    t.index ["company_id"], name: "index_spree_tax_exemption_certificates_on_company_id"
    t.index ["country_code", "state_code"], name: "idx_on_country_code_state_code_21132110e7"
    t.index ["verified_by_id"], name: "index_spree_tax_exemption_certificates_on_verified_by_id"
  end

  create_table "spree_tax_identifiers", force: :cascade do |t|
    t.bigint "cart_id"
    t.bigint "company_id"
    t.datetime "created_at", null: false
    t.bigint "customer_id"
    t.string "kind", null: false
    t.bigint "order_id"
    t.string "source"
    t.datetime "updated_at", null: false
    t.datetime "validated_at"
    t.jsonb "validation_evidence"
    t.string "validation_status"
    t.string "value", null: false
    t.index ["cart_id"], name: "index_spree_tax_identifiers_on_cart_id"
    t.index ["company_id", "kind"], name: "index_spree_tax_identifiers_on_company_id_and_kind", unique: true
    t.index ["company_id"], name: "index_spree_tax_identifiers_on_company_id"
    t.index ["customer_id", "kind"], name: "index_spree_tax_identifiers_on_customer_id_and_kind", unique: true
    t.index ["customer_id"], name: "index_spree_tax_identifiers_on_customer_id"
    t.index ["order_id"], name: "index_spree_tax_identifiers_on_order_id"
  end

  create_table "spree_tax_lines", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.bigint "cart_id"
    t.string "country_code"
    t.datetime "created_at", null: false
    t.jsonb "data"
    t.bigint "fee_id"
    t.bigint "fulfillment_id"
    t.boolean "included", null: false
    t.string "label", null: false
    t.bigint "line_item_id"
    t.jsonb "metadata"
    t.bigint "order_id"
    t.string "provider_id"
    t.decimal "rate", precision: 8, scale: 5, null: false
    t.string "state_code"
    t.bigint "tax_rate_id"
    t.string "taxability_reason"
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_spree_tax_lines_on_cart_id"
    t.index ["country_code", "state_code"], name: "index_spree_tax_lines_on_country_code_and_state_code"
    t.index ["fee_id"], name: "index_spree_tax_lines_on_fee_id"
    t.index ["fulfillment_id"], name: "index_spree_tax_lines_on_fulfillment_id"
    t.index ["line_item_id"], name: "index_spree_tax_lines_on_line_item_id"
    t.index ["order_id"], name: "index_spree_tax_lines_on_order_id"
    t.index ["tax_rate_id"], name: "index_spree_tax_lines_on_tax_rate_id"
    t.index ["taxability_reason"], name: "index_spree_tax_lines_on_taxability_reason"
  end

  create_table "spree_tax_rates", force: :cascade do |t|
    t.decimal "amount", precision: 8, scale: 5
    t.string "country_code"
    t.datetime "created_at", null: false
    t.datetime "deleted_at", precision: nil
    t.boolean "included_in_price", default: false
    t.jsonb "metadata"
    t.string "name"
    t.boolean "show_rate_in_label", default: true
    t.string "state_code"
    t.bigint "store_id"
    t.bigint "tax_category_id"
    t.datetime "updated_at", null: false
    t.bigint "zone_id"
    t.index ["country_code", "state_code"], name: "index_spree_tax_rates_on_country_code_and_state_code"
    t.index ["deleted_at"], name: "index_spree_tax_rates_on_deleted_at"
    t.index ["included_in_price"], name: "index_spree_tax_rates_on_included_in_price"
    t.index ["show_rate_in_label"], name: "index_spree_tax_rates_on_show_rate_in_label"
    t.index ["store_id"], name: "index_spree_tax_rates_on_store_id"
    t.index ["tax_category_id"], name: "index_spree_tax_rates_on_tax_category_id"
    t.index ["zone_id"], name: "index_spree_tax_rates_on_zone_id"
  end

  create_table "spree_taxon_rules", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "match_policy", default: "is_equal_to", null: false
    t.bigint "taxon_id", null: false
    t.string "type", null: false
    t.datetime "updated_at", null: false
    t.string "value", null: false
    t.index ["taxon_id"], name: "index_spree_taxon_rules_on_taxon_id"
  end

  create_table "spree_taxonomies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.jsonb "metadata"
    t.string "name", null: false
    t.integer "position", default: 0
    t.bigint "store_id"
    t.datetime "updated_at", null: false
    t.index ["name", "store_id"], name: "index_spree_taxonomies_on_name_and_store_id", unique: true
    t.index ["position"], name: "index_spree_taxonomies_on_position"
    t.index ["store_id"], name: "index_spree_taxonomies_on_store_id"
  end

  create_table "spree_taxonomy_translations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "locale", null: false
    t.string "name"
    t.bigint "spree_taxonomy_id", null: false
    t.datetime "updated_at", null: false
    t.index ["locale"], name: "index_spree_taxonomy_translations_on_locale"
    t.index ["spree_taxonomy_id", "locale"], name: "index_spree_taxonomy_translations_on_spree_taxonomy_id_locale", unique: true
  end

  create_table "spree_trackers", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "analytics_id"
    t.datetime "created_at", null: false
    t.integer "engine", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_spree_trackers_on_active"
  end

  create_table "spree_user_identities", force: :cascade do |t|
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.jsonb "info"
    t.string "provider", null: false
    t.string "refresh_token"
    t.string "uid", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "user_type", null: false
    t.index ["provider", "uid", "user_type"], name: "index_spree_user_identities_on_provider_uid_user_type", unique: true
    t.index ["user_type", "user_id"], name: "index_spree_user_identities_on_user"
  end

  create_table "spree_users", force: :cascade do |t|
    t.string "authentication_token"
    t.bigint "bill_address_id"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "email"
    t.string "encrypted_password", limit: 128
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_request_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip"
    t.datetime "locked_at", precision: nil
    t.string "login"
    t.jsonb "metadata"
    t.string "password_salt", limit: 128
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "remember_created_at", precision: nil
    t.string "remember_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.bigint "ship_address_id"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unlock_token"
    t.datetime "updated_at", null: false
  end

  create_table "spree_variant_media", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "media_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.index ["media_id"], name: "idx_variant_media_media"
    t.index ["variant_id", "media_id"], name: "idx_variant_media_unique", unique: true
  end

  create_table "spree_variants", force: :cascade do |t|
    t.integer "backorder_limit"
    t.string "barcode"
    t.string "cost_currency"
    t.decimal "cost_price", precision: 10, scale: 2
    t.string "country_of_origin"
    t.datetime "created_at", precision: nil, null: false
    t.string "customs_description"
    t.datetime "deleted_at", precision: nil
    t.bigint "delivery_profile_id"
    t.decimal "depth", precision: 8, scale: 2
    t.string "dimensions_unit"
    t.datetime "discontinue_on", precision: nil
    t.decimal "height", precision: 8, scale: 2
    t.string "hs_code"
    t.boolean "is_master", default: false
    t.integer "media_count", default: 0, null: false
    t.jsonb "metadata"
    t.integer "position"
    t.datetime "preorder_ships_at"
    t.boolean "preorderable"
    t.bigint "primary_media_id"
    t.bigint "product_id"
    t.bigint "seller_id"
    t.string "sku", default: "", null: false
    t.bigint "tax_category_id"
    t.boolean "track_inventory", default: true
    t.datetime "updated_at", precision: nil, null: false
    t.decimal "weight", precision: 8, scale: 2, default: "0.0"
    t.string "weight_unit"
    t.decimal "width", precision: 8, scale: 2
    t.index ["barcode"], name: "index_spree_variants_on_barcode"
    t.index ["deleted_at"], name: "index_spree_variants_on_deleted_at"
    t.index ["delivery_profile_id"], name: "index_spree_variants_on_delivery_profile_id"
    t.index ["discontinue_on"], name: "index_spree_variants_on_discontinue_on"
    t.index ["is_master"], name: "index_spree_variants_on_is_master"
    t.index ["media_count"], name: "index_spree_variants_on_media_count"
    t.index ["position"], name: "index_spree_variants_on_position"
    t.index ["primary_media_id"], name: "index_spree_variants_on_primary_media_id"
    t.index ["product_id"], name: "index_spree_variants_on_product_id"
    t.index ["seller_id"], name: "index_spree_variants_on_seller_id"
    t.index ["sku"], name: "index_spree_variants_on_sku"
    t.index ["tax_category_id"], name: "index_spree_variants_on_tax_category_id"
    t.index ["track_inventory"], name: "index_spree_variants_on_track_inventory"
  end

  create_table "spree_webhook_deliveries", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "delivered_at"
    t.string "error_type"
    t.string "event_id"
    t.string "event_name", null: false
    t.integer "execution_time"
    t.jsonb "payload", null: false
    t.text "request_errors"
    t.text "response_body"
    t.integer "response_code"
    t.boolean "success"
    t.datetime "updated_at", null: false
    t.bigint "webhook_endpoint_id", null: false
    t.index ["delivered_at"], name: "index_spree_webhook_deliveries_on_delivered_at"
    t.index ["event_name"], name: "index_spree_webhook_deliveries_on_event_name"
    t.index ["response_code"], name: "index_spree_webhook_deliveries_on_response_code"
    t.index ["success"], name: "index_spree_webhook_deliveries_on_success"
    t.index ["webhook_endpoint_id", "event_id"], name: "index_spree_webhook_deliveries_on_endpoint_and_event", unique: true, where: "(event_id IS NOT NULL)"
    t.index ["webhook_endpoint_id"], name: "index_spree_webhook_deliveries_on_webhook_endpoint_id"
  end

  create_table "spree_webhook_endpoints", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.datetime "disabled_at"
    t.string "disabled_reason"
    t.string "name"
    t.string "secret_key", null: false
    t.bigint "store_id", null: false
    t.jsonb "subscriptions", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.index ["active"], name: "index_spree_webhook_endpoints_on_active"
    t.index ["deleted_at"], name: "index_spree_webhook_endpoints_on_deleted_at"
    t.index ["store_id"], name: "index_spree_webhook_endpoints_on_store_id"
  end

  create_table "spree_wished_items", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "variant_id"
    t.bigint "wishlist_id"
    t.index ["variant_id", "wishlist_id"], name: "index_spree_wished_items_on_variant_id_and_wishlist_id", unique: true
    t.index ["variant_id"], name: "index_spree_wished_items_on_variant_id"
    t.index ["wishlist_id"], name: "index_spree_wished_items_on_wishlist_id"
  end

  create_table "spree_wishlists", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.bigint "customer_id"
    t.boolean "is_default", default: false, null: false
    t.boolean "is_private", default: true, null: false
    t.string "name"
    t.bigint "store_id"
    t.string "token", null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["customer_id", "is_default"], name: "index_spree_wishlists_on_customer_id_and_is_default"
    t.index ["customer_id"], name: "index_spree_wishlists_on_customer_id"
    t.index ["store_id"], name: "index_spree_wishlists_on_store_id"
    t.index ["token"], name: "index_spree_wishlists_on_token", unique: true
  end

  create_table "spree_zone_members", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "zone_id"
    t.bigint "zoneable_id"
    t.string "zoneable_type"
    t.index ["zone_id", "zoneable_type", "zoneable_id"], name: "index_spree_zone_members_uniqueness", unique: true
    t.index ["zone_id"], name: "index_spree_zone_members_on_zone_id"
  end

  create_table "spree_zones", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "default_tax", default: false
    t.string "description"
    t.string "kind", default: "state"
    t.string "name"
    t.datetime "updated_at", null: false
    t.integer "zone_members_count", default: 0
    t.index ["default_tax"], name: "index_spree_zones_on_default_tax"
    t.index ["kind"], name: "index_spree_zones_on_kind"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "spree_category_translations", "spree_categories"
  add_foreign_key "spree_option_type_translations", "spree_option_types"
  add_foreign_key "spree_option_value_translations", "spree_option_values"
  add_foreign_key "spree_payment_sources", "spree_payment_methods", column: "payment_method_id"
  add_foreign_key "spree_product_translations", "spree_products"
  add_foreign_key "spree_store_translations", "spree_stores"
  add_foreign_key "spree_taxonomy_translations", "spree_taxonomies"
end
