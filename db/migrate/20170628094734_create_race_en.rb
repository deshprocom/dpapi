class CreateRaceEn < ActiveRecord::Migration[5.0]
  def change
    create_table :race_ens do |t|
      t.references :race
      t.text :description
      t.string :logo, limit: 256, comment: '赛事的logo'
      t.string :name, limit: 256, comment: '赛事的名称'
      t.string :prize, limit: 256, comment: '赛事的奖池'
      t.string :location, limit:256, comment: '赛事比赛地点'
      t.string :ticket_price, limit:256, comment: '买入'
      t.string :blind, limit:256, comment: '盲注'
    end
  end
end
