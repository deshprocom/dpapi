class CreateAffiliateApps < ActiveRecord::Migration[5.0]
  def change
    create_table :affiliate_apps do |t|
      t.references :affiliate, foreign_key: true
      t.string :app_id, limit: 50
      t.string :app_name, limit: 100
      t.string :app_key, limit: 36
      t.string :app_secret, limit: 36
      t.integer :status, default: 0

      t.timestamps
    end

    add_index :affiliate_apps, :app_key, unique: true
  end
end
