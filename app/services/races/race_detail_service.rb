module Services
  module Account
    class RaceDetailService
      include Serviceable
      attr_accessor :user_uuid, :race_id

      def initialize(user_uuid, race_id)
        self.user_uuid = user_uuid
        self.race_id = race_id
      end

      def call
        # 查询是否有这个赛事
        race = Race.find(race_id)
        ApiResult.success_with_data(race: race, user: User.by_uuid(user_uuid))
      end
    end
  end
end
