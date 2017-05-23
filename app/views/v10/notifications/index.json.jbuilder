# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.notifications do
    json.array! @current_user.notifications.limit(20) do |notification|
      json.id            notification.id
      json.notify_type   notification.notify_type
      json.title         notification.title
      json.content       notification.content
      json.created_at    notification.created_at.to_i
    end
  end
end
