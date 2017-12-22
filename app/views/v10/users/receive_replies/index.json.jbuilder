# rubocop:disable Metrics/BlockLength
# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @dynamics do |item|
      typological = item.unscoped_typological

      typological_type = item.typological_type.downcase
      if item.deleted_type?
        json.type 'delete'
        json.typological_type typological_type
        json.id typological.id
        json.my_comment typological.body
        json.created_at typological.created_at.to_i
      else
        next if typological&.replies.blank?
        typological.replies.each do |list|
          json.type 'reply'
          json.mine do
            json.id typological.id
            json.comment typological.body
            json.created_at typological.created_at.to_i
            json.partial! 'v10/topic/user_info', user: typological.user
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
