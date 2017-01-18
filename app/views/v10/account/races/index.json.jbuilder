# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! race do |item|
      json.name          item[:name].to_s
      json.logo          item[:logo].to_s
      json.prize         item[:prize]
      json.location      item[:location].to_s
      json.start_time    item[:start_time]
      json.end_time      item[:end_time]
      json.status        item[:status]
      json.followed      item.is_follow?(user.try(:id))
      json.ordered       item.is_order?(user.try(:id))
    end
  end
end
