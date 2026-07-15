# This migration comes from spree (originally 20260627000001)
class AddProductsCountToSpreeTaxons < ActiveRecord::Migration[7.2]
  def change
    add_column :spree_taxons, :products_count, :integer, default: 0, null: false, if_not_exists: true
    add_index :spree_taxons, :products_count, if_not_exists: true
  end
end
