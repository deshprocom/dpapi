class ChangeTicketInfoToInnoDb < ActiveRecord::Migration[5.0]
  def change
    change_table :ticket_infos, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do

    end
  end
end
