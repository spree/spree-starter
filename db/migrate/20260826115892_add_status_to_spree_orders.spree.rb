# This migration comes from spree (originally 20260429000003)
class AddStatusToSpreeOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_orders, :status, :string
    add_index :spree_orders, :status
  end
end
