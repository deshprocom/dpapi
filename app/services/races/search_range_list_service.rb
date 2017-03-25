# rubocop:disable Metrics/MethodLength
module Services
  module Races
    class SearchRangeListService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :search_params, :user_uuid

      def initialize(user_uuid, search_params)
        self.search_params = search_params
        self.user_uuid = user_uuid
      end

      def call
        begin_date = search_params[:begin_date]
        end_date = search_params[:end_date]
        user = User.by_uuid(user_uuid)
        race_lists = Race.select('id, begin_date')
                         .where('begin_date >= ?', begin_date)
                         .where('end_date <= ?', end_date)
                         .order(begin_date: :asc)

        list_result = {}
        race_lists.reduce(list_result) do |races_map, race|
          begin_date = race.begin_date.to_s
          item = races_map[begin_date]

          if item.nil?
            races_map[begin_date] = item = { begin_date: begin_date, follows: 0, orders: 0, counts: 0 }
          end

          item[:counts] += 1
          item[:follows] = item[:follows] + 1 if RaceFollow.followed?(user.try(:id), race.id)
          item[:orders] = item[:orders] + 1 if PurchaseOrder.purchased?(user.try(:id), race.id)
          races_map
        end

        ApiResult.success_with_data(race: list_result)
      end
    end
  end
end
