class CreateRaceDescs < ActiveRecord::Migration[5.0]
  def change
    create_table :race_descs do |t|
      t.references :race, foreign_key: true
      t.text :description
      t.timestamps
    end
  end
end
