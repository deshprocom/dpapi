class CreateRegions < ActiveRecord::Migration[5.0]
  def change
    create_table :regions do |t|
      t.string :name, limit: 100, comment: '所属区域'
      t.timestamps
    end
  end
end
