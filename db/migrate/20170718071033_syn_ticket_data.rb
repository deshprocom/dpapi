class SynTicketData < ActiveRecord::Migration[5.0]
  def change
    Ticket.all.each do |ticket|
      next if ticket.ticket_en

      TicketEn.create(ticket.attributes)
    end
  end
end
