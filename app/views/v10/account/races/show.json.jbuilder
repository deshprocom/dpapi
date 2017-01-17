# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.name         race[:name]
  json.logo         race[:logo]
  json.prize        race[:prize]
  json.location     race[:location]
  json.start_time   race[:start_time]
  json.end_time     race[:end_time]
  json.status       race[:status]
  json.description  race[:description]
end
