class CreateRaceFollows < ActiveRecord::Migration[5.0]
  def change
    create_table :race_follows do |t|
      t.references :user, foreign_key: true
      t.references :race, foreign_key: true
      t.timestamps
    end
  end
end
