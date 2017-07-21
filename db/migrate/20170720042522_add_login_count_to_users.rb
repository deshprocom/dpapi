class AddLoginCountToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :role, :string, default: 'basic', column: '用户角色'
    add_column :users, :login_count, :integer, default: 0, column: '用户登录次数'
    add_column :users, :mark, :string, default: '', column: '用户备注，运营人员用'
  end
end
