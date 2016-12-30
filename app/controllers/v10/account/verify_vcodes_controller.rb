VCODE_TYPES = %w(login register reset_pwd).freeze

module V10
  module Account
    # 校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      include Constants::Error::Sign

      def create
        # 判断验证码验证的类型是否符合
        render_api_error(VCODE_TYPE_WRONG) unless params[:type].in?(VCODE_TYPES)
        vcode_service = Services::Account::VerifyVcodeService
        api_result = vcode_service.call(send_params[:type], send_params[:mobile], send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def send_params
        params.permit(:type, :vcode, :mobile)
      end
    end
  end
end
