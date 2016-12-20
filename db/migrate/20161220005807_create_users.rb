class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :user_uuid, limit: 36, null:false, comment: "用户的uuid"
      t.string :user_name, limit: 32, comment: "用户姓名, 唯一"
      t.string :nick_name, limit: 32, comment: "用户的昵称"
      t.string :password,  comment: "用户的密码"
      t.string :password_salt, default:"", null: false, comment: "密码盐值"
      t.integer :gender, default: 0, comment: "用户的性别, 0表示男， 1表示女"
      t.string :email, limit: 64, comment: "用户的邮箱 唯一"
      t.string :mobile, limit: 16, comment: "用户手机号 唯一"
      t.string :avatar, limit: 255, comment: "用户头像"
      t.string :birthday, limit: 8, comment: "用户的生日"
      t.timestamps
    end

    add_index :users, :user_uuid, unique: true
    add_index :users, :user_name, unique: true
    add_index :users, :email, unique: true
    add_index :users, :mobile, unique: true
  end
end
