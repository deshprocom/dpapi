class CreateAccountChangeStats < ActiveRecord::Migration[5.0]
  def change
    create_table :account_change_stats do |t|
      t.references :user
      t.datetime :change_time
      t.string :account_type, default: 'mobile', comment: '修改账户的类别 mobile or email'
      t.string :mender, default: '', comment: '修改者'
      t.timestamps
    end
  end
end
