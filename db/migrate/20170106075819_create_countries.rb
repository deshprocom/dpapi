class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.references :region, foreign_key: true
      t.string :name, limit: 100, comment: '国家名字'
      t.string :icon, limit: 100, comment: '国家图标'
      t.timestamps
    end
  end
end
