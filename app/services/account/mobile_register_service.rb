module Services
  module Account
    class MobileRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :mobile, :vcode, :password

      def initialize(mobile, vcode, password = nil)
        self.mobile = mobile
        self.vcode = vcode
        self.password = password
      end

      def call
        # 检查手机格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(mobile)

        # TODO: 验证逻辑需要移到新的验证码校验类
        # 检查验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless vcode == mobile[-4, 4]

        # 检查手机号是否存在
        if UserValidator.mobile_exists?(mobile)
          return ApiResult.error_result(MOBILE_ALREADY_USED)
        end

        # 检查密码是否合法
        if password.present? && !UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        # 可以注册, 创建一个用户
        user = User.create_by_mobile(mobile, password)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
