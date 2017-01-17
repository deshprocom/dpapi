module Services
  module Account
    class RaceListService
      include Serviceable
      attr_accessor :user_uuid

      def initialize(user_uuid)
        self.user_uuid = user_uuid
      end

      def call
      end
    end
  end
end
