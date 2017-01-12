module Services
  module Account
    class ResetPwdByEmailService
      include Serviceable

      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :email, :vcode, :password

      def initialize(email, vcode, password)
        self.email = email
        self.vcode = vcode
        self.password = password
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def call
        # 检查参数是否为空
        if email.blank? || vcode.blank? || password.blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # TODO: 验证逻辑需要移到新的验证码校验类
        # 检查验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) unless vcode == 'abcd'

        # 查询用户
        user = User.by_email(email)
        return ApiResult.error_result(USER_NOT_FOUND) if user.nil?

        # 创建新的用户密码
        salt = SecureRandom.hex(6).slice(0, 6)
        new_password = ::Digest::MD5.hexdigest("#{password}#{salt}")

        user.update(password: new_password, password_salt: salt)
        ApiResult.success_result
      end
    end
  end
end
