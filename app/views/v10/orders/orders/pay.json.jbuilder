# meta info
json.partial! 'common/meta'
# code & msg
json.result do
  json.code order['code']
  json.msg order['msg']
  json.data order['body'].to_s
end