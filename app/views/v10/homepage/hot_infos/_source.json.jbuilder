if source.class.name == 'Info'
  json.info do
    json.id          source.id
    json.title       source.title.to_s
    json.date        source.date
    json.image_thumb source.image_thumb.to_s
    json.description source.description.to_s
    json.source_type source.source_type.to_s
    json.source      source.source.to_s
  end
else
  json.video do
    json.id             source.id
    json.name           source.name.to_s
    json.title_desc     source.title_desc.to_s
    json.video_link     source.video_link.to_s
    json.cover_link     source.cover_link.to_s
    json.video_duration source.video_duration.to_s
    json.description    source.description.to_s
  end
end