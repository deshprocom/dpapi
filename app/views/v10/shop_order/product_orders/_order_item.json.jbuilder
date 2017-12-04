json.id             item.id
json.product_id     item.variant&.product&.id
json.title          item.variant&.product&.title
json.original_price item.original_price
json.price          item.price
json.number         item.number
json.sku_value      item.sku_value
json.refund_status     item.refund_status
json.seven_days_return item.seven_days_return
json.image             item.variant&.image&.preview
unless item.refund_status.eql?('none')
  json.refund_number item.product_refund_details.last.product_refund.refund_number
end