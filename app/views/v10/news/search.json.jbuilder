# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! news do |list|
      json.id          list.id
      json.type_id     list.info_type_id
      json.type        list.info_type.try(:name).to_s
      json.title       list.title.to_s
      json.date        list.date.to_s
      json.source_type list.source_type.to_s
      json.source      list.source.to_s
      json.image       list.image.to_s
      json.image_thumb list.image_thumb.to_s
      json.top         list.top
      json.description list.description.to_s
    end
  end
  json.next_id next_id.to_s
end
