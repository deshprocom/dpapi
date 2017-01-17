class CreateRaceSubscribes < ActiveRecord::Migration[5.0]
  def change
    create_table :race_subscribes do |t|
      t.references :users, foreign_key: true
      t.references :races, foreign_key: true
      t.timestamps
    end
  end
end
