json.id                ticket.id
json.title             ticket.title.to_s
json.price             ticket.price
json.original_price    ticket.original_price
json.ticket_class      ticket.ticket_class.to_s
json.description       ticket.description.to_s
json.status            ticket.status
json.ticket_info do
  json.partial! 'ticket_info', ticket_info: ticket.ticket_info
end