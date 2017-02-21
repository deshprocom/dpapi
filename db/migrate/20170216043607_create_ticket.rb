class CreateTicket < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :user
      t.references :race
      t.references :ticket_infos, foreign_key: true
      t.string :cert_type, limit: 50,
               default: 'chinese_id',
               comment: '证件类型  chinese_id-中国身份证'
      t.string :cert_no, comment: '证件号码'
      t.string :ticket_type, limit: 30,
               default: 'e_ticket',
               comment: '票的类型 e_ticket-电子票, entity_ticket-实体票'
      t.string :status, limit: 30,
               default: 'unpaid',
               comment: '票的状态 unpaid-未付款, paid-已付款, canceled-取消'
      t.string :memo, comment: '备忘'
      t.timestamps
    end
  end
end
