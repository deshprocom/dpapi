# required
WxPay.appid = ENV['APP_ID']
WxPay.key = ENV['APP_KEY']
WxPay.mch_id = ENV['MCH_ID']

# if you want to use `generate_authorize_req` and `authenticate`
WxPay.appsecret = ENV['APP_SECRET']

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = { timeout: 2, open_timeout: 3 }