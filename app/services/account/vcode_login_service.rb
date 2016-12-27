module Services
  module Account
    class VcodeLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode

      def initialize(mobile, vcode)
        self.mobile = mobile
        self.vcode = vcode
      end

      def call
        if mobile.blank? or vcode.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        #查询用户是否存在
        user = User.by_mobile(mobile)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        #检查用户输入的验证码是否正确
        if vcode != mobile[-4, 4]
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end

        #刷新上次访问时间
        user.touch_visit!

        #生成用户令牌
        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end