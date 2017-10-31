json.array! products do |product|
  json.id             product.id
  json.category_id    product.category_id
  json.title          product.title
  json.icon           product.preview_icon
  json.price          888.00
  json.all_stock      88
end