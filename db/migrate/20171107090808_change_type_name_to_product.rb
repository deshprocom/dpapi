class ChangeTypeNameToProduct < ActiveRecord::Migration[5.0]
  def change
    add_column :products, :product_type, :string
    remove_column(:products, :type)
  end
end
