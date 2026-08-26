# This migration comes from spree (originally 20260402000002)
class AddColorCodeToSpreeOptionValues < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_option_values, :color_code, :string
  end
end
