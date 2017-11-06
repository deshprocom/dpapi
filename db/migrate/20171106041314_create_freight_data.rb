class CreateFreightData < ActiveRecord::Migration[5.0]
  def up
    return if Freight.count > 0
    Freight.create(id: 1, name: '重量', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1)
    Freight.create(id: 2, name: '件数', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1)
    Freight.create(id: 3, name: '体积', first_cond: 1, first_price: 1, add_cond: 1, add_price: 1)
  end

  def down
    Freight.destroy_all
  end
end
