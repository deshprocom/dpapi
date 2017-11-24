class InsertFreTypeToFreight < ActiveRecord::Migration[5.0]
  def change
    return unless Freight.count > 0
    Freight.all.where(name: '重量').update(freight_type: 'weight')
    Freight.all.where(name: '件数').update(freight_type: 'number')
    Freight.all.where(name: '体积').update(freight_type: 'volume')
  end
end
