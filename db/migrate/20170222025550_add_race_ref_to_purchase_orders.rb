class AddRaceRefToPurchaseOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :purchase_orders, :race
  end
end
