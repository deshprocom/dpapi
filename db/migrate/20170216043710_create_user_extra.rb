class CreateUserExtra < ActiveRecord::Migration[5.0]
  def change
    create_table :user_extras do |t|
      t.references :user
      t.string :real_name, limit: 50, comment: '真实姓名'
      t.string :cert_type, limit: 50,
               default: 'chinese_id',
               comment: '证件类型  chinese_id-中国身份证'
      t.string :cert_no, comment: '证件号码'
      t.string :memo, comment: '备忘'
      t.string :image, limit: 255, default: '', comment: '身份证图片'
      t.string :image_md5, limit: 32, default: '', null: false, comment: '图片md5'
      t.string :status, limit:20, default: 'pending', comment: '审核中-pending, 审核通过-passed, 审核失败-failed'
      t.timestamps
    end
  end
end
