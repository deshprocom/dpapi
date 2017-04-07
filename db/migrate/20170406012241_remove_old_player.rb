class RemoveOldPlayer < ActiveRecord::Migration[5.0]
  def change
    drop_table :player_matches
    drop_table :player_rankings
    drop_table :players
    drop_table :matches
    drop_table :countries
    drop_table :regions
  end
end
