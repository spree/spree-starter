# This migration comes from spree_paypal_checkout (originally 20250528095719)
class CreateSpreePaypalCheckoutOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_paypal_checkout_orders do |t|
      t.references :order, null: false
      t.references :payment_method, null: false
      t.string :paypal_id, null: false
      t.decimal :amount, null: false, precision: 10, scale: 2

      if t.respond_to? :jsonb
        t.jsonb :data
      else
        t.json :data
      end

      t.timestamps
    end

    add_index :spree_paypal_checkout_orders, [:order_id, :paypal_id], unique: true
  end
end
