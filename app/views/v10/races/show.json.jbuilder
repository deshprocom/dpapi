# rubocop:disable Metrics/BlockLength
# meta info
json.partial! 'common/meta'
# code & msg
json.partial! 'common/api_result', api_result: ApiResult.success_result
# data
json.data do
  json.race_id         @race.id
  json.name            @race.name.to_s
  json.seq_id          @race.seq_id
  json.logo            @race.preview_logo
  json.big_logo        @race.big_logo
  json.prize           @race.prize
  json.location        @race.location.to_s
  json.begin_date      @race.begin_date
  json.end_date        @race.end_date
  json.status          @race.status
  json.ticket_status   @race.ticket_status
  json.ticket_price    @race.ticket_price
  json.ticket_sellable @race.ticket_sellable
  json.describable     @race.describable
  json.description     @race.race_desc.try(:description).to_s
  json.followed        RaceFollow.followed?(@user&.id, @race.id)
  order = PurchaseOrder.purchased_order(@user&.id, @race.id)
  json.ordered         order.present?
  json.order_id        order&.order_number

  json.schedules do
    schedules = @race.race_schedules.default_order
    json.array! schedules do |schedule|
      json.partial! 'v10/races/schedule', race_schedule: schedule
    end
  end

  json.ranks do
    ranks = @race.race_ranks
    json.array! ranks do |rank|
      json.partial! 'v10/races/rank', rank: rank
    end
  end
end
