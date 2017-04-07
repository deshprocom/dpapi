class CreatePlayerScores < ActiveRecord::Migration[5.0]
  def change
    create_table :player_scores do |t|
      t.references :race
      t.string :player_id, limit: 32, comment: '牌手的uuid'
      t.integer :earning
      t.integer :score
    end
  end
end
