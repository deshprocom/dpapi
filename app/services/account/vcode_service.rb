module Services
  module Account
    class VcodeServices
      COMMON_SMS_TEMPLATE = '您的验证码是: %s, 请不要把验证码泄漏给其他人。'.freeze
      RESET_PWD_SMS_TEMPLATE = '您申请重置本站的登录密码，如确认是您本人申请，请使用本验证码完成操作：%s，否则请勿将验证码泄露给任何人。'.freeze

      include Serviceable

      attr_accessor :user_params

      def initialize(user_params)
        self.user_params = user_params
      end

      def call
        sms_template = if user_params[:option_type].eql?('reset_pwd')
                         RESET_PWD_SMS_TEMPLATE
                       else
                         COMMON_SMS_TEMPLATE
                       end
        vcode_type = user_params[:vcode_type]
        account_id = user_params[:"#{vcode_type}"]
        return ApiResult.error_result(MISSING_PARAMETER) if account_id.blank?
        send("send_#{user_params[:vcode_type]}_vcodes", user_params[:option_type], sms_template, account_id)
      end

      private

      def send_mobile_vcodes(option_type, sms_template, account_id)
        vcode = VCode.generate_mobile_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
      end

      def send_email_vcodes(option_type, sms_template, account_id)
        vcode = VCode.generate_email_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
      end
    end
  end
end
