# This migration comes from spree_stripe (originally 20250310152812)
class SetupSpreeStripeModels < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_stripe_payment_intents do |t|
      t.decimal :amount, precision: 10, scale: 2, default: '0.0', null: false
      t.bigint :order_id, null: false
      t.bigint :payment_method_id, null: false
      t.string :stripe_id, null: false
      t.string :client_secret, null: false
      t.string :customer_id
      t.string :ephemeral_key_secret
      t.string :stripe_payment_method_id

      t.timestamps

      t.index ['order_id', 'stripe_id'], name: 'index_spree_stripe_payment_intents_on_order_id_and_stripe_id', unique: true
      t.index ['order_id'], name: 'index_spree_stripe_payment_intents_on_order_id'
      t.index ['payment_method_id'], name: 'index_spree_stripe_payment_intents_on_payment_method_id'
    end

    create_table :spree_stripe_webhook_keys do |t|
      t.string :stripe_id, null: false
      t.string :signing_secret, null: false

      t.timestamps

      t.index ['signing_secret'], name: 'index_spree_stripe_webhook_keys_on_signing_secret', unique: true
      t.index ['stripe_id'], name: 'index_spree_stripe_webhook_keys_on_stripe_id', unique: true
    end

    create_table :spree_stripe_payment_methods_webhook_keys do |t|
      t.bigint :payment_method_id, null: false
      t.bigint :webhook_key_id, null: false

      t.timestamps

      t.index ['payment_method_id', 'webhook_key_id'], name: 'index_payment_method_id_webhook_key_id_uniqueness', unique: true
      t.index ['payment_method_id'], name: 'index_payment_methods_webhook_keys_on_payment_method_id'
      t.index ['webhook_key_id'], name: 'index_payment_methods_webhook_keys_on_webhook_key_id'
    end
  end
end
