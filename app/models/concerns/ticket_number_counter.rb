##
# 票数计数器
#
module TicketNumberCounter
  extend ActiveSupport::Concern

  def sold_a_e_ticket
    ticket_info.increment!(:e_ticket_sold_number)
    update(ticket_status: 'sold_out') if ticket_info.sold_out?
  end

  def return_a_e_ticket
    ticket_info.decrement!(:e_ticket_sold_number)
    update(ticket_status: 'selling') if ticket_status == 'sold_out'
  end
end
