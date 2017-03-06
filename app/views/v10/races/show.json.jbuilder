# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.race_id       race.id
  json.name          race.name.to_s
  json.seq_id        race.seq_id
  json.logo          race.logo.to_s
  json.prize         race.prize
  json.location      race.location.to_s
  json.begin_date    race.begin_date
  json.end_date      race.end_date
  json.status        race.status
  json.ticket_status race.ticket_status
  json.ticket_price  race.ticket_price
  json.description   race.race_desc.try(:description).to_s
  json.followed      RaceFollow.followed?(user&.id, race.id)
  order =  PurchaseOrder.purchased_order(user&.id, race.id)
  json.ordered       order.present?
  json.order_number  order&.order_number
end
