class EngInfo < ActiveRecord::Migration[5.0]
  def change
    create_table :eng_infos do |t|
      t.references :info
      t.string :title, comment: '资讯名称'
      t.string :source, comment: '来源内容'
      t.text   :description, comment: '图文内容'
      t.timestamps
    end
  end
end
