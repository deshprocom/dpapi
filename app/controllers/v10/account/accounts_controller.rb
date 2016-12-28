ALLOW_TYPES = %w(email mobile).freeze

module V10
  module Account
    # 处理注册相关的业务逻辑
    class AccountsController < ApplicationController
      include Constants::Error::Common

      def create
        register_type = params[:type]
        unless ALLOW_TYPES.include?(register_type)
          return render_api_error(UNSUPPORTED_TYPE)
        end
        send("register_by_#{register_type}")
      end

      private

      def register_by_mobile
        mobile_register_service = Services::Account::MobileRegisterService
        api_result = mobile_register_service.call(user_params[:mobile], user_params[:vcode])
        render_api_result api_result
      end

      def register_by_email
        email_register_service = Services::Account::EmailRegisterService
        api_result = email_register_service.call(user_params[:email], user_params[:password])
        render_api_result api_result
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/users/base'
        app_access_token = result.data.delete(:app_access_token)
        view_params = {
          api_result: result,
          user: result.data[:user],
          app_access_token: app_access_token
        }
        render template, locals: view_params
      end

      def user_params
        params.permit(:type, :email, :mobile, :password, :vcode)
      end
    end
  end
end
