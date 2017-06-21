# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race do
    json.race_id      @race.id
    json.name         @race.name.to_s
    json.location     @race.location.to_s
    json.begin_date   @race.begin_date
    json.end_date     @race.end_date
    json.logo         @race.logo.to_s
  end

  prices = @race.tickets.pluck(:price)
  json.max_price prices.max
  json.min_price prices.min
  json.tickets do
    json.array! @race.tickets.client_visible do |ticket|
      json.partial! 'ticket', ticket: ticket
    end
  end
end