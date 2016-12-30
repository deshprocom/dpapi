VCODE_TYPES = %w(login register reset_pwd).freeze

module V10
  module Account
    #校验验证码是否正确
    class VerifyVcodesController < ApplicationController
      include Constants::Error::Sign
      before_action :init

      def create
        vcode_service = Services::Account::VerifyVcodeService
        api_result = vcode_service.call(send_params[:type], send_params[:mobile], send_params[:vcode])
        render_api_error(api_result.code, api_result.msg)
      end

      private

      def init
        unless params[:type].in?(VCODE_TYPES)
          render_api_error(VCODE_TYPE_WRONG)
        end
      end

      def send_params
        params.permit(:type, :vcode, :mobile)
      end
    end
  end
end
