class CreateSmsLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :sms_logs do |t|
      t.string :sid, comment: '短信服务商返回回来的短信id'
      t.string :mobile
      t.string :content
      t.string :status, default: 'sending', comment: '发送中-sending, 成功-success, 失败-failed'
      t.string :error_msg, comment: '返回回来的错误信息'
      t.integer :fee, default: 0, comment: '短信计费条数'
      t.datetime :send_time, comment: '发送时间'
      t.datetime :arrival_time, comment: '到达时间'
      t.timestamps
    end
  end
end
