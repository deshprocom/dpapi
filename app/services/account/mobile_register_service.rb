module Services
  module Account
    class MobileRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode

      def initialize(mobile, vcode)
        self.mobile = mobile
        self.vcode = vcode
      end

      def call
        #检查手机格式是否正确
        unless UserValidator.mobile_valid?(mobile)
          return ApiResult.error_result(MOBILE_FORMAT_WRONG)
        end

        #检查验证码是否正确
        if vcode != mobile[-4, 4]
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end

        #检查手机号是否存在
        if UserValidator.mobile_exists?(mobile)
          return ApiResult.error_result(MOBILE_ALREADY_USED)
        end

        #可以注册, 创建一个用户
        user = User.create_by_mobile(mobile)

        #生成用户令牌
        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end