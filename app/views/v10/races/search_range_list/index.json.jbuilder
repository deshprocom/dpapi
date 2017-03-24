# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: api_result
# data
json.data do
  json.items do
    json.array! race do |item|
      # json."#{item[0]}" do
        json.begin_date item[1][:begin_date].to_s
        json.race_count item[1][:race_count].to_i
        json.follow_number item[1][:follow_number].to_i
        json.order_number item[1][:order_number].to_i
      # end
    end
  end
end
