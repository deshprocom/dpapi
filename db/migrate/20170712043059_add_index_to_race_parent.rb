class AddIndexToRaceParent < ActiveRecord::Migration[5.0]
  def change
    add_index :races, :parent_id
  end
end
