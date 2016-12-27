module Services
  module Account
    class EmailRegisterService
      include Serviceable

      include Constants::CommonErrorCode
      include Constants::SignErrorCode

      attr_accessor :email, :password

      def initialize(email, password)
        self.email = email
        self.password = password
      end

      def call
        #检查邮箱格式是否正确
        unless UserValidator.email_valid?(email)
          return ApiResult.error_result(EMAIL_FORMAT_WRONG)
        end

        #检查邮箱是否存在
        if UserValidator.email_exists?(email)
          return ApiResult.error_result(EMAIL_ALREADY_USED)
        end

        #检查密码是否为空
        unless UserValidator.pwd_valid?(password)
          return ApiResult.error_result(PASSWORD_FORMAT_WRONG)
        end

        #可以注册, 创建一个用户
        user = User.create_user_by_email(email, password)

        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end