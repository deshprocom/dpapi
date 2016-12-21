LOGIN_TYPES = %w(email mobile vcode).freeze

module V10
  module Account
    class SessionsController < ApplicationController
      include Constants::CommonErrorCode

      def create
        login_type = params[:type]
        unless LOGIN_TYPES.include?(login_type)
          return render_api_error(UNSUPPORTED_TYPE)
        end
        send("login_by_#{login_type}", login_params)
      end

      private
      def login_by_vcode(user_params)
        api_result = Services::Account::LoginService.login_by_vcode(user_params[:mobile], user_params[:vcode])
        render_api_user(api_result)
      end

      def login_by_email(user_params)
        api_result = Services::Account::LoginService.login_by_email(user_params[:email], user_params[:password])
        render_api_user(api_result)
      end

      def render_api_user(api_result)
        if api_result.is_failure?
          render_api_error(api_result.code, api_result.msg)
        else
          template = "v10/account/users/base"
          data = api_result.data
          render template, locals: {api_result: ApiResult.success, user: data[:user]}
        end
      end

      def login_params
        params.permit(:type, :mobile, :email, :vcode, :password)
      end
    end
  end
end
