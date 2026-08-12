# This migration comes from spree_adyen (originally 20250630150000)
class SetupSpreeAdyenModels < ActiveRecord::Migration[7.2]
  def change
    create_table :spree_adyen_payment_sessions do |t|
      t.decimal :amount, precision: 10, scale: 2, default: '0.0', null: false, index: true
      t.string :currency, null: false
      t.references :order, null: false, index: true
      t.references :user, null: true, index: true
      t.string :status, null: false, index: true
      t.datetime :expires_at, null: false, index: true
      t.datetime :deleted_at, index: true
      t.references :payment_method, null: false, index: true
      t.string :adyen_id, null: false, index: { unique: true }
      t.text :adyen_data, null: false
      t.timestamps
    end
  end
end
