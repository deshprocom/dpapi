class AddExtraToNotifications < ActiveRecord::Migration[5.0]
  def change
    add_column :notifications, :extra_data, :text, comment: '使用json存额外信息'
    add_column :notifications, :color_type, :string, comment: '颜色类型：success 成功，failure 失败'
  end
end
