# This migration comes from spree (originally 20260818000001)
class RenameSpreePaymentsStateToStatus < ActiveRecord::Migration[8.1]
  def change
    rename_column :spree_payments, :state, :status
  end
end
