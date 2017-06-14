class ExtendTicketIdToTicketInfo < ActiveRecord::Migration[5.0]
  def change
    add_reference :ticket_infos, :tickets
  end
end
