module Services
  module Account
    class RaceListService
      include Serviceable
      attr_accessor :user_uuid, :type

      def initialize(user_uuid, type)
        self.user_uuid = user_uuid
        self.type = type
      end

      def call
        send("#{type}_race_lists")
      end

      private

      # 查询近期更多赛事
      def recent_race_lists
        ApiResult.success_with_data({ race: Race.recent_races, user: User.by_uuid(user_uuid) })
      end

      # 查询历史更多赛事
      def history_race_lists
        Race.history_races
      end
    end
  end
end
