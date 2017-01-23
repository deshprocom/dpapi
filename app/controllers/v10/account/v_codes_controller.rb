module V10
  module Account
    # 发送验证码的接口
    class VCodesController < ApplicationController
      OPTION_TYPES = %w(register login reset_pwd change_pwd).freeze
      VCODE_TYPES = %w(mobile email).freeze
      include Constants::Error::Sign

      def create
        return render_api_error(VCODE_TYPE_WRONG) unless user_params[:vcode_type].in?(VCODE_TYPES)
        return render_api_error(UNSUPPORTED_OPTION_TYPE) unless user_params[:option_type].in?(OPTION_TYPES)
        api_result = Services::Account::VcodeServices.call(user_params)
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def user_params
        params.permit(:option_type, :vcode_type, :mobile, :email)
      end
    end
  end
end
