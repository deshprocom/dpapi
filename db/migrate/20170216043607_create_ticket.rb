class CreateTicket < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :user
      t.references :race
      t.references :ticket_infos, foreign_key: true
      t.string :ticket_type, limit: 30,
               default: 'e_ticket',
               comment: '票的类型 e_ticket-电子票, entity_ticket-实体票'
      t.string :status, limit: 30,
               default: 'unpaid',
               comment: '票的状态 unpaid-未付款, paid-已付款, canceled-取消'
      t.string :memo, comment: '备忘'
    end
  end
end
