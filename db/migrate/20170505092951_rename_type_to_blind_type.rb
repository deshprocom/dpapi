class RenameTypeToBlindType < ActiveRecord::Migration[5.0]
  def change
    remove_column :race_blinds, :type
    add_column :race_blinds, :blind_type, :integer,
               default: 0,
               comment: '0表示有盲注，前注这些结构， 1表示有文字输入'
  end
end
