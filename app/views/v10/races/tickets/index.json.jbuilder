# rubocop:disable Metrics/BlockLength

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
    json.prize        @race.prize
    json.ticket_price @race.ticket_price
    json.tickets do
      json.array! @race.tickets do |ticket|
        json.partial! 'ticket', ticket: ticket
      end
    end
  end

  json.sub_races do
    json.array! @race.sub_races.date_asc do |race|
      json.race_id         race.id
      json.name            race.name.to_s
      json.prize           race.prize
      json.ticket_price    race.ticket_price
      json.blind           race.blind
      json.location        race.location.to_s
      json.begin_date      race.begin_date
      json.end_date        race.end_date
      json.days            race.days
      json.roy             race.roy
      json.tickets do
        json.array! race.tickets do |ticket|
          json.partial! 'ticket', ticket: ticket
        end
      end
    end
  end
end