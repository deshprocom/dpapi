# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.ios_version @ios_version&.version.to_s
  json.android_version @android_version&.version.to_s
end
