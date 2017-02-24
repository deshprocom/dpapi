class CreateOrderSnapshot < ActiveRecord::Migration[5.0]
  def change
    create_table :order_snapshots do |t|
      t.references :purchase_order
      t.references :race
      t.string :name, limit: 256, comment: '赛事的名称'
      t.string :logo, limit: 256, comment: '赛事的logo'
      t.integer :prize, default:0, null: false, comment: '赛事的奖池'
      t.string :location, limit:256, comment: '赛事比赛地点'
      t.integer :ticket_price , default:0, comment: '票的价格'
      t.date :begin_date, comment: '赛事开始日期'
      t.date :end_date, comment: '赛事结束的日期'
    end
  end
end