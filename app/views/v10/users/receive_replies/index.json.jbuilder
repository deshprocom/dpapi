# rubocop:disable Metrics/BlockLength
# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @dynamics do |item|
      typological_type = item.typological_type.downcase
      if item.deleted_type?
        json.delete do
          json.typological_type typological_type
          json.id item.typological.id
          json.my_comment item.typological.body
          json.created_at item.typological.created_at.to_i
        end
      else
        next if item.typological&.replies.blank?
        json.reply_list do
          json.array! item.typological.replies do |list|
            json.mine do
              json.typological_type typological_type
              json.id item.typological.id
              json.comment item.typological.body
              json.created_at item.typological.created_at.to_i
              json.partial! 'v10/topic/user_info', user: item.typological.user
            end
            json.other do
              json.id list.id
              json.comment list.body
              json.created_at list.created_at.to_i
              json.partial! 'v10/topic/user_info', user: list.user
            end
          end
        end
      end
    end
  end
end
