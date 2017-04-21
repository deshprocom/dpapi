class AddHostToRace < ActiveRecord::Migration[5.0]
  def change
    add_reference :races, :race_host
  end
end
