class CreatePurchaseOrder < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_orders do |t|
      t.references :user
      t.references :ticket
      t.string :ticket_type, limit: 30,
               default: 'e_ticket',
               comment: '票的类型 e_ticket-电子票, entity_ticket-实体票'
      t.string :email, comment: '电子票发送邮箱'
      t.string :address, comment: '实体票邮寄地址'
      t.string :consignee, limit: 50, comment: '收货人'
      t.string :mobile, limit: 50, comment: '联系方式'
      t.string :status, limit: 30,
               default: 'unpaid',
               comment: '订单状态 unpaid-未付款, paid-已付款, unshipped-待发货, completed-已完成, canceled-已取消'
      t.timestamps
    end
  end
end
