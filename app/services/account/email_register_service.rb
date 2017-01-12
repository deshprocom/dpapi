module Services
  module Account
    class EmailRegisterService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :email, :password

      def initialize(email, password)
        self.email = email
        self.password = password
      end

      def call
        # 检查邮箱格式是否正确
        unless UserValidator.email_valid?(email)
          return ApiResult.error_result(EMAIL_FORMAT_WRONG)
        end

        # 检查邮箱是否存在
        if UserValidator.email_exists?(email)
          return ApiResult.error_result(EMAIL_ALREADY_USED)
        end

        # 可以注册, 创建一个用户
        user = User.create_by_email(email, password)

        # 生成用户令牌
        secret = CurrentRequestCredential.affiliate_app.try(:app_secret)
        access_token = AppAccessToken.jwt_create(secret, user.user_uuid)
        LoginResultHelper.call(user, access_token)
      end
    end
  end
end
