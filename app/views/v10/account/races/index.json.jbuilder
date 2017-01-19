# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! race do |item|
      json.name          item[:name].to_s
      json.seq_id        item[:seq_id].to_s
      json.logo          item[:logo].to_s
      json.prize         item[:prize]
      json.location      item[:location].to_s
      json.begin_date    item[:begin_date]
      json.end_date      item[:end_date]
      json.status        item[:status]
      json.followed      item.followed?(user.try(:id))
      json.ordered       item.ordered?(user.try(:id))
    end
  end
end
