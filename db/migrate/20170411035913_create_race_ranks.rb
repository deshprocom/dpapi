class CreateRaceRanks < ActiveRecord::Migration[5.0]
  def change
    create_table :race_ranks do |t|
      t.references :race
      t.references :player
      t.integer :ranking, comment: '排名'
      t.integer :earning, comment: '收入奖金'
      t.integer :score, comment: '得分'
    end
  end
end
