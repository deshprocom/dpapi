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
        # 验证码或手机号是否为空
        return ApiResult.error_result(MISSING_PARAMETER) if mobile.blank? || vcode.blank?

        # 查询用户是否存在
        user = User.by_mobile(mobile)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 检查用户输入的验证码是否正确
        # TODO: 验证逻辑需要移到新的验证码校验类
        return ApiResult.error_result(VCODE_NOT_MATCH) if vcode != mobile[-4, 4]

        # 刷新上次访问时间
        user.touch_visit!

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
