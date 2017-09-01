# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.activities do
    json.array! @activities do |activity|
      json.id            activity.id
      json.title         activity.title
      json.banner        activity.banner
      json.activity_time activity.activity_time
    end
  end
end
