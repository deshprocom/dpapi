class CreateTicketInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_infos do |t|
      t.references :race, foreign_key: true
      t.integer :total_number, default:0, comment: '总票数'
      t.integer :e_ticket_number, default:0, comment: '总电子票数'
      t.integer :entity_ticket_number, default:0, comment: '总实体票数'
      t.integer :e_ticket_sold_number, default:0, comment: '已售电子票数'
      t.integer :entity_ticket_sold_number, default:0, comment: '已售实体票数'
      t.timestamps
    end
  end
end
