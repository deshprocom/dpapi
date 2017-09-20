class AddWxAvatarToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :user_extra, :wx_avatar, :string
  end
end
