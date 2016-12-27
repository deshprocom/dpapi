module Services
  module Account
    class EmailLoginService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :email, :password

      def initialize(email, password)
        self.email = email
        self.password = password
      end

      def call
        if email.blank? or password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        user = User.by_email(email)
        #判断该用户是否存在
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        #查询出了这个用户  对比密码
        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        unless salted_passwd.eql?(user.password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        #登录
        user.touch_visit!
        #生成用户令牌
        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end