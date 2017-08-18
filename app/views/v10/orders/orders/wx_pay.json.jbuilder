# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result

json.data do
  json.appid order[:appid].to_s
  json.mch_id order[:partnerid].to_s
  json.nonce_str order[:package].to_s
  json.sign order[:timestamp].to_s
  json.prepay_id order[:prepayid].to_s
  json.trade_type order[:nonce_str].to_s
  json.trade_type order[:sign].to_s
end
