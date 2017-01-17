class CreateRaceOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :race_orders do |t|
      t.references :races, foreign_key: true
      t.references :users, foreign_key: true
      t.timestamps
    end
  end
end
