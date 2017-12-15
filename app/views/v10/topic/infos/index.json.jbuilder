# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @comments do |comment|
      json.id comment.id
      json.body comment.body
      json.recommended comment.recommended
      json.created_at comment.created_at.to_i
      json.partial! 'v10/topic/user_info', resource: comment
      json.typological 'comment'
    end
  end
end
