json.id             video.id
json.name           video.name.to_s
json.type_id        video.video_type_id
json.type           video.video_type.try(:name).to_s
json.tag_id         video.race_tag_id
json.tag            video.race_tag.try(:name).to_s
json.group_id       video.video_group_id
json.group_name     video.video_group.try(:name).to_s
json.title_desc     video.title_desc.to_s
json.video_link     video.video_link.to_s
json.cover_link     video.cover_link.to_s
json.video_duration video.video_duration.to_s
json.top            false
json.is_main        video.is_main
json.description    video.description.to_s
json.created_at     video.created_at.to_i
json.total_views    video.total_views
json.total_likes    video.total_likes