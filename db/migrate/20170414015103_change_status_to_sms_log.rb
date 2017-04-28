class ChangeStatusToSmsLog < ActiveRecord::Migration[5.0]
  def change
    remove_column :sms_logs, :status
    add_column :sms_logs, :status, :string,
               default: 'sending',
               comment: '发送中-sending, 成功-success, 失败-failed'
  end
end
