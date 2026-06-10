# This migration comes from spree (originally 20260508204042)
class AddPreferredStockLocationToSpreeOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :spree_orders, :preferred_stock_location
  end
end
