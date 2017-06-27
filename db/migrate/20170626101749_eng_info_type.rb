class EngInfoType < ActiveRecord::Migration[5.0]
  def change
    create_table :eng_info_types do |t|
      t.references :info_type
      t.string :name, comment: 'Info name'
      t.timestamps
    end
  end
end