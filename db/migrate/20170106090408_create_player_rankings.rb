class CreatePlayerRankings < ActiveRecord::Migration[5.0]
  def change
    create_table :player_rankings do |t|
      t.references :player, foreign_key: true
      t.references :ranking_type, foreign_key: true
      t.date :date, comment: '比赛的日期'
      t.string :team, limit: 100, comment: '比赛的小组'
      t.string :score, limit: 100, comment: '比赛的积分'
      t.integer :ranking, comment: '比赛排名'
      t.integer :last_ranking, comment: '上次排名'
      t.string :position
      t.string :higgest
      t.timestamps
    end
  end
end
