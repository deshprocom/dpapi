class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.references :race
      t.string  :title, limit: 256, comment: '票名称'
      t.string  :logo, limit: 256, comment: '票缩略图'
      t.boolean :ticket_sellable, default: true, comment: '是否售票'
      t.integer :price, comment: '折后价格'
      t.integer :original_price, comment: '原始价格'
      t.string  :type, default: 'race', comment: '类型:race -> 仅赛票, race_extra -> 套票'
      t.timestamps
    end
  end
end
