module V10
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      OPTION_TYPES = %w(login register reset_pwd).freeze
      VCODE_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign

      def create
        # 判断验证码验证的类型是否符合
        return render_api_error(VCODE_TYPE_WRONG) unless send_params[:vcode_type].in?(VCODE_TYPES)
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless send_params[:option_type].in?(OPTION_TYPES)
        send("#{send_params[:vcode_type]}_verify_vcode")
      end

      private

      def mobile_verify_vcode
        mobile_verify_service = Services::Account::MobileVerifyVcodeService
        api_result = mobile_verify_service.call(send_params[:mobile], send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      def email_verify_vcode
        email_verify_service = Services::Account::EmailVerifyVcodeService
        api_result = email_verify_service.call(send_params[:email], send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      def send_params
        params.permit(:option_type, :vcode_type, :vcode, :mobile, :email)
      end
    end
  end
end
