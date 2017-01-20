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
        return ApiResult.error_result(RACE_NOT_FOUND) unless Race.exists?(id: race_id)

        # 存在赛事，查看是否有赛事详情
      end
    end
  end
end
