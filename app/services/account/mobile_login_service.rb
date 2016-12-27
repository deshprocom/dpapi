module Services
  module Account
    class MobileLoginService
      include Serviceable

      # include Constants::Error::Commons
      include Constants::CommonErrorCode
      include Constants::SignErrorCode

      attr_accessor :mobile, :password

      def initialize(mobile, password)
        self.mobile = mobile
        self.password = password
      end

      def call
        if mobile.blank? or password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        user = User.by_mobile(mobile)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        salted_passwd = ::Digest::MD5.hexdigest(password + user.password_salt)
        unless salted_passwd.eql?(user.password)
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        user.touch_visit!
        #生成用户令牌
        app_access_token = AppAccessToken.from_credential(CurrentRequestCredential, user.user_uuid)
        LoginResultHelper.call(user, app_access_token)
      end
    end
  end
end
