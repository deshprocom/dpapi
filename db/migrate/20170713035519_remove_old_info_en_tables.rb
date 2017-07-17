class RemoveOldInfoEnTables < ActiveRecord::Migration[5.0]
  def change
    drop_table :info_ens
    drop_table :info_type_ens
  end
end
