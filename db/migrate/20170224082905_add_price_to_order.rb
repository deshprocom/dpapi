class AddPriceToOrder < ActiveRecord::Migration[5.0]
  def up
    unless PurchaseOrder.columns_hash.has_key? 'price'
      add_column :purchase_orders, :price, :integer, comment: '价格'
    end
    unless PurchaseOrder.columns_hash.has_key? 'price'
      add_column :purchase_orders, :original_price, :integer, comment: '原始价格'
    end
  end
end
