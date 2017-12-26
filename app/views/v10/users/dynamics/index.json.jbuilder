# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @dynamics do |item|
      typological = item.unscoped_typological
      topic = item.unscoped_typological_topic

      json.id item.id
      json.created_at item.created_at.to_i
      json.topic_type typological.topic_type.downcase
      json.topic do
        json.topic_id typological.topic_id
        json.topic_image topic.big_image
        json.topic_title topic.title
        json.topic_description topic.description
      end
      json.typological_type item.typological_type.downcase
      json.typological do
        if item.typological_type.casecmp('comment').zero?
          json.partial! 'comment', item: typological
        elsif item.typological_type.casecmp('reply').zero?
          json.partial! 'reply', item: typological
        end
      end
    end
  end
end
