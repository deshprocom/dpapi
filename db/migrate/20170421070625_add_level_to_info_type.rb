class AddLevelToInfoType < ActiveRecord::Migration[5.0]
  def change
    add_column :info_types, :level, :integer, comment: '类别排序级别'
  end
end
