module Services
  module Account
    class RaceDetailService
      include Serviceable
      attr_accessor :mobile, :vcode

      def initialize(mobile, vcode)
        self.mobile = mobile
        self.vcode = vcode
      end

      def call
      end
    end
  end
end
