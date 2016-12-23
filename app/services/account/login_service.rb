module Services
  module Account
    class LoginService
      include Constants::HttpErrorCode
      include Constants::CommonErrorCode
      include Constants::SignErrorCode

      def self.login_by_vcode(mobile, vcode)
        if mobile.blank? or vcode.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        #查询用户是否存在
        user = User.by_mobile(mobile)
        if user.nil?
          return ApiResult.error_result(USER_NOT_FOUND)
        end

        #检查用户输入的验证码是否正确
        if vcode != mobile[-4, 4]
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end

        #移除验证码

        #登录
        build_login_result user

      end

      def self.login_by_email(email, password)
        if email.blank? or password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        user = User.by_email(email)
        if user.nil?
          return ApiResult.error_result(USER_NOT_FOUND)
        end

        #查询出了这个用户  对比密码
        password_salt = user.password_salt
        true_password = ::Digest::MD5.hexdigest(password + password_salt)

        if user.password != true_password or password.blank?
          return ApiResult.error_result(PASSWORD_NOT_MATCH)
        end

        #登录
        build_login_result user
      end

      private
      def self.build_login_result(user)
        user.last_visit = Time.now
        user.save
        #生成用户令牌
        app_access_token = AppAccessToken.create(CurrentRequestCredential.client_ip,
                                                 CurrentRequestCredential.app_key,
                                                 CurrentRequestCredential.affiliate_app.try(:app_secret),
                                                 user.user_uuid)

        data = {
            user: user,
            app_access_token: app_access_token
        }

        ApiResult.success_with_data(data)
      end
    end
  end
end