class CreateVideoTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :video_types do |t|
      t.string :name
      t.integer :level, default: 0, comment: '排序'
      t.boolean :published, default: false, comment: '是否发布'
      t.timestamps
    end
  end
end
