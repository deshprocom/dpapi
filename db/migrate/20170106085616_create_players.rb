class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.references :country, foreign_key: true
      t.string  :first_name, limit: 100
      t.string  :last_name, limit: 100
      t.string  :avatar, limit: 100, comment: '牌手头像'
      t.integer :gender, default: 0, comment: "牌手的性别, 0表示男， 1表示女, 2未知"
      t.string  :gpid, limit: 32, comment: 'unique id of players'
      t.string  :spider_id, limit: 64, comment: '方便爬虫用'
      t.string  :hometown, limit: 100
      t.string  :residence , limit: 100
      t.integer :best_cash
      t.integer :all_time_money
      t.timestamps
    end
  end
end
