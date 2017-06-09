class RemoveTicketInfosReference < ActiveRecord::Migration[5.0]
  def change
    remove_reference :ticket_infos, :tickets
    add_reference :ticket_infos, :ticket
  end
end
