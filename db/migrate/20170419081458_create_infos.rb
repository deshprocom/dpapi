class CreateInfos < ActiveRecord::Migration[5.0]
  def change
    create_table :infos do |t|
      t.references :info_type
      t.string :title, comment: '资讯标题'
      t.date :date, comment: '资讯时间'
      t.string :source_type, default: 'source', comment: 'source 来源, author 作者'
      t.string :source, comment: '内容'
      t.string :image, comment: '图片'
      t.string :image_thumb, comment: '图片小图'
      t.boolean :top, default: false, comment: '是否置顶'
      t.boolean :published, default: false, comment: '是否发布'
      t.text :description, comment: '图文内容'
      t.timestamps
    end
  end
end
