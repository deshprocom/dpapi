# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.activity do
    json.id            @activity.id
    json.title         @activity.title
    json.banner        @activity.banner
    json.pushed_img    @activity.pushed_img
    json.description   @activity.description
    json.activity_time @activity.activity_time
  end
end
