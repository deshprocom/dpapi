json.order_number           order.order_number
json.status                 order.status
json.shipping_price         order.shipping_price
json.total_product_price    order.total_product_price
json.total_price            order.total_price
json.created_at             order.created_at.to_i
if order.status.eql?('canceled')
  json.cancelled_at           order.cancelled_at.to_i
  json.cancel_reason          order.cancel_reason.to_s
end