module Services
  module Account
    class RaceDetailService
      include Serviceable
      include Constants::Error::Race
      attr_accessor :user_uuid, :race_id

      def initialize(user_uuid, race_id)
        self.user_uuid = user_uuid
        self.race_id = race_id
      end

      def call
        # 查询是否有这个赛事
        race = Race.by_race_id(race_id)
        return ApiResult.error_result(RACE_NOT_FOUND) if race.blank?
        ApiResult.success_with_data(race: race, user: User.by_uuid(user_uuid))
      end
    end
  end
end
