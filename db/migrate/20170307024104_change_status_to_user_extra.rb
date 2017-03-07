class ChangeStatusToUserExtra < ActiveRecord::Migration[5.0]
  def change
    change_column :user_extras, :status, :string,
                  limit:20,
                  default: 'init',
                  comment: '初始化-init, 审核中-pending, 审核通过-passed, 审核失败-failed'
  end
end
