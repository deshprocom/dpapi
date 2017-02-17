class TicketInfo < ApplicationRecord
  belongs_to :race

  def e_ticket_sold_out?
    e_ticket_sold_number >= e_ticket_number
  end

  def e_ticket_sold_increase
    self.class.update_counters id, e_ticket_sold_number: 1
  end

  def sold_out?
    e_ticket_sold_number >= e_ticket_number && entity_ticket_sold_number >= entity_ticket_number
  end
end
