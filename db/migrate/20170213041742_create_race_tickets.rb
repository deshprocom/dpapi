class CreateRaceTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :race_tickets do |t|
      t.references :race, foreign_key: true
      t.string :name, limit: 100, comment: '票的名称'
      t.integer :price, default:0, comment: '票的价格'
      t.string :status, limit: 30,
               default: 'selling',
               comment: '售票的状态 selling-售票中, end-售票结束, sold_out-票已售完'
      t.timestamps
    end
  end
end
