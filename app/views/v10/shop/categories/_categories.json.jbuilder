json.array! categories do |category|
  json.id    category.id
  json.name  category.name
  json.image category.preview_image
end