class ExtendAvatarMd5ToPlayer < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :avatar_md5, :string, { limit: 32, default: '', null: false, comment: '用户图像md5' }
  end
end
