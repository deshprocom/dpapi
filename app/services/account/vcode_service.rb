module Services
  module Account
    class VcodeServices
      COMMON_SMS_TEMPLATE = '您的验证码是：%s，请不要把验证码泄漏给其他人。'.freeze
      COMMON_SMS_TITLE = '请激活您的帐号，完成注册'.freeze
      RESET_PWD_SMS_TEMPLATE = '您申请重置本站的登录密码，如确认是您本人申请，请使用本验证码完成操作：%s，否则请勿将验证码泄露给任何人。'.freeze
      RESET_PWD_TITLE = '重设您的密码'.freeze
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :user_params

      def initialize(user_params)
        self.user_params = user_params
      end

      def call
        sms_template = user_params[:option_type].eql?('reset_pwd') ? RESET_PWD_SMS_TEMPLATE : COMMON_SMS_TEMPLATE
        vcode_type = user_params[:vcode_type]
        account_id = user_params[:"#{vcode_type}"]
        return ApiResult.error_result(MISSING_PARAMETER) if account_id.blank?
        api_result = check_params(user_params[:option_type], account_id)
        if api_result.failure?
          api_result
        else
          send("send_#{user_params[:vcode_type]}_vcodes", user_params[:option_type], sms_template, account_id)
        end
      end

      private

      def send_mobile_vcodes(option_type, sms_template, account_id)
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(account_id)
        vcode = VCode.generate_mobile_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
        SendMobileSmsJob.set(queue: 'send_mobile_sms').perform_later(option_type, account_id, sms_content)
        ApiResult.success_result
      end

      def send_email_vcodes(option_type, sms_template, account_id)
        return ApiResult.error_result(EMAIL_FORMAT_WRONG) unless UserValidator.email_valid?(account_id)
        account_id = account_id.downcase
        vcode = VCode.generate_email_vcode(option_type, account_id)
        sms_content = format(sms_template, vcode)
        Rails.logger.info "send [#{sms_content}] to #{account_id} in queue"
        sms_title = option_type.eql?('reset_pwd') ? RESET_PWD_TITLE : COMMON_SMS_TITLE
        SendEmailSmsJob.set(queue: 'send_email_sms').perform_later(option_type, account_id, sms_content, sms_title)
        ApiResult.success_result
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      def check_params(option_type, account_id)
        # 发送之前检验用户存在性
        if option_type.eql?('register')
          # 要求用户不存在
          if User.by_email(account_id).present? || User.by_mobile(account_id).present?
            return ApiResult.error_result(USER_ALREADY_EXIST)
          end
        end
        unless option_type.eql?('register')
          # 要求用户存在
          if User.by_email(account_id).nil? && User.by_mobile(account_id).nil?
            return ApiResult.error_result(USER_NOT_FOUND)
          end
        end
        ApiResult.success_result
      end
    end
  end
end
