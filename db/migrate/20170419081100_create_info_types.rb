class CreateInfoTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :info_types do |t|
      t.string :name, comment: '类别的名称'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end
  end
end
