class CreateTicketEn < ActiveRecord::Migration[5.0]
  def change
    create_table :ticket_ens do |t|
      t.references :ticket
      t.string  :title, limit: 256, comment: '票名称'
      t.integer :price, comment: '折后价格'
      t.integer :original_price, comment: '原始价格'
      t.text :description, comment: '赛票描述'
    end
  end
end
