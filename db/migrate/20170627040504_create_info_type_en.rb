class CreateInfoTypeEn < ActiveRecord::Migration[5.0]
  def change
    create_table :info_type_ens do |t|
      t.references :info_type
      t.string :name, comment: 'Info name'
      t.timestamps
    end
  end
end
