class AddIndexToRace < ActiveRecord::Migration[5.0]
  def change
    add_index :races, :seq_id, unique: true
    add_index :races, :begin_date
  end
end
