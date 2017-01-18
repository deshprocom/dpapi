module Services
  module Account
    class RaceRecentService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :number, :user_uuid

      def initialize(user_uuid, number)
        self.user_uuid = user_uuid
        self.number = number
      end

      def call
        nums = number.to_i.eql?(0) ? nil : number.to_i
        ApiResult.success_with_data(race: Race.limit_recent_races(nums), user: User.by_uuid(user_uuid))
      end
    end
  end
end
