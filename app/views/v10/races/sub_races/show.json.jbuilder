# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race_id         @sub_race.id
  json.name            @sub_race.name.to_s
  json.prize           @sub_race.prize
  json.ticket_price    @sub_race.ticket_price
  json.blind           @sub_race.blind
  json.location        @sub_race.location.to_s
  json.begin_date      @sub_race.begin_date
  json.end_date        @sub_race.end_date
  json.days            @sub_race.days
  json.participants    @sub_race.participants
  json.roy             @sub_race.roy
  json.schedule        @sub_race.race_desc.schedule
end
