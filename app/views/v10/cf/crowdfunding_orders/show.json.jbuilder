# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.order_info do
    json.partial! 'order_info', order: @order
  end

  json.crowdfunding_player do
    json.partial! 'v10/cf/players/short_info', cf_player: @order.crowdfunding_player
  end

  json.race do
    json.partial! 'v10/cf/crowdfundings/race_info', race: @order.crowdfunding.race
  end

  json.crowdfunding do
    json.partial! 'v10/cf/crowdfundings/crowdfunding', crowdfunding: @order.crowdfunding
  end
end
