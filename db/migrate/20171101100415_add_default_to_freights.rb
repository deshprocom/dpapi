class AddDefaultToFreights < ActiveRecord::Migration[5.0]
  def change
    add_column :freights, :default, :boolean, default: false, comment: '是否默认'
  end
end
