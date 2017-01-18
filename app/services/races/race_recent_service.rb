module Services
  module Account
    class RaceRecentService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :numbers, :user_uuid

      def initialize(user_uuid, numbers)
        self.user_uuid = user_uuid
        self.numbers = numbers
      end

      def call
        nums = numbers.to_i.eql?(0) ? nil : numbers.to_i
        ApiResult.success_with_data(race: Race.limit_recent_races(nums), user: User.by_uuid(user_uuid))
      end
    end
  end
end
