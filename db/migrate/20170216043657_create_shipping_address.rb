class CreateShippingAddress < ActiveRecord::Migration[5.0]
  def change
    create_table :shipping_addresses do |t|
      t.references :user
      t.string :consignee, limit: 50, comment: '收货人'
      t.string :mobile, limit: 50, comment: '联系方式'
      t.string :address, comment: '所在地'
      t.string :address_detail, comment: '详细地址'
      t.string :post_code, limit: 50, comment: '邮政编码'
      t.boolean :default, default: 0, comment: '是否为默认地址'
      t.timestamps
    end
  end
end
