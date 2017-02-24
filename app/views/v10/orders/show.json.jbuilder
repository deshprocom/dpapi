# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.order_info do
    json.partial! 'v10/orders/order_info', order_info: order_info
  end
  json.race_info do
    json.partial! 'v10/orders/race_snapshot', race_info: race_info
  end
end

