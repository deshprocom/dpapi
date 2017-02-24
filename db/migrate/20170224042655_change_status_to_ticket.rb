class ChangeStatusToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :canceled, :boolean,
               default: false,
               comment: '该票是否取消'
    remove_column :tickets, :status
    remove_column :tickets, :cert_type
    remove_column :tickets, :cert_no
  end
end
