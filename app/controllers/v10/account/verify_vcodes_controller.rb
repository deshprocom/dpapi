module V10
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      OPTION_TYPES = %w(register login reset_pwd change_pwd bind_account unbind_account
                        change_old_account bind_new_account).freeze
      include Constants::Error::Sign

      def create
        # 判断验证码验证的类型是否符合
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless send_params[:option_type].in?(OPTION_TYPES)
        vcode_verify_service = Services::Account::VcodeVerifyService
        api_result = vcode_verify_service.call(send_params[:option_type], send_params[:account], send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def send_params
        params.permit(:option_type, :account, :vcode)
      end
    end
  end
end
