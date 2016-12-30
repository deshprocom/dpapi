class AddSignatureToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :signature, :string, { limit: 64, default: '', null: false, comment: '个性签名' }
  end
end
