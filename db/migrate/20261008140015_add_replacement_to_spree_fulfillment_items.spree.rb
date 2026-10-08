# This migration comes from spree (originally 20260925000001)
class AddReplacementToSpreeFulfillmentItems < ActiveRecord::Migration[8.1]
  def change
    add_column :spree_fulfillment_items, :replacement, :boolean, default: false, null: false
  end
end
