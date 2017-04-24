json.array! races do |race|
  json.race_id         race.id
  json.name            race.name.to_s
  json.seq_id          race.seq_id.to_i
  json.logo            race.preview_logo
  json.big_logo        race.big_logo
  json.prize           race.prize
  json.location        race.location.to_s
  json.begin_date      race.begin_date
  json.end_date        race.end_date
  json.status          race.status
  json.ticket_status   race.ticket_status
  json.ticket_sellable race.ticket_sellable
  json.describable     race.describable
  json.followed        RaceFollow.followed?(user.try(:id), race.id)
  json.ordered         PurchaseOrder.purchased?(user.try(:id), race.id)
end