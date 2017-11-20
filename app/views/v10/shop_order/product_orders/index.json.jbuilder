# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.items do
    json.array! orders do |order|
      json.partial! 'v10/shop_order/product_orders/order_info', order: order
      json.order_items do
        json.array! order.product_order_items do |item|
          json.title          item.variant&.product&.title
          json.original_price item.original_price
          json.price          item.price
          json.number         item.number
          json.sku_value      item.sku_value
          json.refunded       item.refunded
          json.image          item.variant&.image&.preview
        end
      end
      json.address do
        json.name        order.product_shipping_address&.name.to_s
        json.mobile      order.product_shipping_address&.mobile.to_s
        json.province    order.product_shipping_address&.province.to_s
        json.city        order.product_shipping_address&.city.to_s
        json.area        order.product_shipping_address&.area.to_s
        json.address     order.product_shipping_address&.address.to_s
      end
    end
  end
end