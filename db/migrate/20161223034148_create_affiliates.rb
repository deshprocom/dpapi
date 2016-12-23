class CreateAffiliates < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliates do |t|
      t.string :aff_uuid, limit: 36
      t.string :aff_name, limit: 100
      t.string :aff_type, limit: 50, default: 'company'
      t.integer :status, default: 0
      t.string :mobile, limit: 20
      t.timestamps
    end

    add_index :affiliates, :aff_uuid, unique: true
    add_index :affiliates, :aff_name, unique: true
    add_index :affiliates, :mobile, unique: true
  end
end
