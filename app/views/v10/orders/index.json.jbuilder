# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! order_lists do |item|
      json.order_info do
        json.partial! 'v10/orders/order_info', order_info: item[:order_info]
      end
      json.race_info do
        json.partial! 'v10/orders/race_snapshot', race_info: item[:race_info]
      end
    end
  end
  json.next_id next_id.to_s
end

