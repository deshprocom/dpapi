class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.references :video_type
      t.string :name, comment: '视频名称'
      t.string :video_link, comment: '视频链接'
      t.string :cover_link, comment: '封面链接'
      t.boolean :top, default: false, comment: '是否置顶'
      t.boolean :published, default: false, comment: '是否发布'
      t.text :description, comment: '视频描述'
      t.timestamps
    end
  end
end
