json.id          list.id
json.type_id     list.video_type_id
json.type        list.video_type.try(:name).to_s
json.name        list.name.to_s
json.video_link  list.video_link.to_s
json.cover_link  list.cover_link.to_s
json.top         false
json.description list.description.to_s
