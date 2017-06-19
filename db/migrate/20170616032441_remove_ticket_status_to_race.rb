class RemoveTicketStatusToRace < ActiveRecord::Migration[5.0]
  def change
    remove_column :races, :ticket_status
  end
end
