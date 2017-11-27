class CreateProductRefunds < ActiveRecord::Migration[5.0]
  def change
    create_table :product_refunds do |t|
      t.references :product_order_item
      t.string :refund_number, limit: 32, null: false, comment: '商品退款编号'
      t.decimal :refund_price, null: false, precision: 8, scale: 2, comment: '退款金额'
      t.string :refund_type, default: 'back', comment: '退换货类型back,change'
      t.string :memo, comment: '申请退换原因'
      t.string :admin_memo, comment: '审核结果原因'
      t.string :status, default: 'open', comment: '退换货状态open审核中, close关闭或审核不通过, passed审核通过, completed完成'
      t.timestamps
    end
  end
end
