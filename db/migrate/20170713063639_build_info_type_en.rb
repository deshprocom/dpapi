class BuildInfoTypeEn < ActiveRecord::Migration[5.0]
  def change
    create_table :info_type_ens do |t|
      t.string :name, comment: '类别的名称'
      t.boolean :published, default: false, comment: '是否发布'
      t.integer :level, default: 0, comment: '类别排序级别'
      t.timestamps
    end
  end
end
