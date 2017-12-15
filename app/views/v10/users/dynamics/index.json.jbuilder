# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! @dynamics do |item|
      json.id item.id
      json.created_at item.created_at.to_i
      json.topic_type item.typological.topic_type.downcase
      json.topic do
        json.topic_id item.typological.topic_id
        json.topic_image  item.typological.topic.big_image
        json.topic_title  item.typological.topic.title
        json.topic_description item.typological.topic.description
      end
      json.typological_type  item.typological_type.downcase
      json.typological do
        if item.typological_type.downcase.eql?('comment')
          json.partial! 'comment', item: item.typological
        elsif item.typological_type.downcase.eql?('reply')
          json.partial! 'reply', item: item.typological
        end
      end
    end
  end
end
