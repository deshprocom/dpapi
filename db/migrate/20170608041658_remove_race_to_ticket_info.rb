class RemoveRaceToTicketInfo < ActiveRecord::Migration[5.0]
  def change
    remove_reference :ticket_infos, :race, foreign_key: true
  end
end
