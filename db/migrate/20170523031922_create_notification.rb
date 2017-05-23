class CreateNotification < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false
      t.string :notify_type, null: false, comment: '消息类型:order 订单, certification 实名认证'
      t.string :title, null: false, comment: '标题'
      t.text :content, null: false, comment: '内容'
      t.references :source, polymorphic: true, comment: '产生消息的出处'
    end
  end
end
