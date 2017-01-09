class CreatePlayerMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :player_matches do |t|
      t.references :players, foreign_key: true
      t.integer :buy_in
      t.integer :rank, comment: '排名'
      t.integer :entries
      t.integer :earnings
      t.decimal :gpi, precision: 5, scale: 2
      t.timestamps
    end
  end
end
