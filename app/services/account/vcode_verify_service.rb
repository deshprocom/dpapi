module Services
  module Account
    class VcodeVerifyService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign
      attr_accessor :type, :account, :vcode

      def initialize(type, account, vcode)
        self.type = type
        self.account = account
        self.vcode = vcode
      end

      def call
        return ApiResult.error_result(MISSING_PARAMETER) if account.blank?
        if User.by_email(account).nil? && User.by_mobile(account).nil?
          return ApiResult.error_result(USER_NOT_FOUND)
        end
        # 这段为了暂时保持功能完整添加，后面需要移除
        unless UserValidator.email_valid?(account)
          # 判断验证码是否正确
          return ApiResult.error_result(VCODE_NOT_MATCH) if vcode != account[-4, 4]
          # 验证码正确
          return ApiResult.success_result
        end

        # 检查验证码是否正确
        unless VCode.check_vcode(type, account, vcode)
          return ApiResult.error_result(VCODE_NOT_MATCH)
        end

        # 验证码正确
        ApiResult.success_result
      end
    end
  end
end
