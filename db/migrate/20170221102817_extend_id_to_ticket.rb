class ExtendTicketInfoToRace < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :cert_type, :string,
               limit: 50,
               default: 'chinese_id',
               comment: '证件类型  chinese_id-中国身份证'
    add_column :tickets, :cert_no, :string,
               comment: '证件号码'
  end
end
