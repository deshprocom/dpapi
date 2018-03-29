json.user do
  json.partial! 'v10/users/user_info', user: topic.user
end
json.id               topic.id
json.title            topic.title
json.body             topic.body
json.body_type        topic.body_type
json.recommended      topic.recommended
json.published        topic.published
json.published_time   topic.published_time.to_i
json.abnormal         topic.abnormal
json.location do
  json.lat topic.lat
  json.lng topic.lng
end
json.deleted          topic.deleted
json.deleted_at       topic.deleted_at.to_i
json.deleted_reason   topic.deleted_reason
json.created_at       topic.created_at.to_i

if topic&.topic_images.present?
  json.images do
    json.array! topic.topic_images do |image|
      json.image_url image&.image_path.to_s
    end
  end
end

json.partial! 'v10/users/user_topics/counter', topic: topic