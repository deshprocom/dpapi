# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.name         race[:name].to_s
  json.seq_id       race[:seq_id].to_s
  json.logo         race[:logo].to_s
  json.prize        race[:prize]
  json.location     race[:location].to_s
  json.begin_date   race[:begin_date]
  json.end_date     race[:end_date]
  json.status       race[:status]
  json.description  race.race_desc.try(:description).to_s
  json.followed     race.followed?(user.try(:id))
  json.ordered      race.ordered?(user.try(:id))
end
