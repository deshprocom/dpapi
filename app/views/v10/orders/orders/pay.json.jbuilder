# meta info
json.partial! 'common/meta'
# code & msg
json.code order['code'].eql?('0000') ? 0 : order['code']
json.msg order['msg']
json.data order['body'].to_s