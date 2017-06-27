class RemoveOldEngInfoTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :eng_infos
    drop_table :eng_info_types
  end
end
