module Services
  module Account
    class EmailVerifyVcodeService
      include Serviceable
      include Constants::Error::Sign
      attr_accessor :email, :vcode

      def initialize(email, vcode)
        self.email = email
        self.vcode = vcode
      end

      def call
        # 检查邮箱格式是否正确
        return ApiResult.error_result(EMAIL_FORMAT_WRONG) unless UserValidator.email_valid?(email)

        # 判断验证码是否正确
        return ApiResult.error_result(VCODE_NOT_MATCH) if vcode != 'abcd'

        # 验证码正确
        ApiResult.success_result
      end
    end
  end
end
