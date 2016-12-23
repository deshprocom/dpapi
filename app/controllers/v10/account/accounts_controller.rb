ALLOW_TYPES = %w(email mobile).freeze

module V10
  module Account
    class AccountsController < ApplicationController
      include Constants::CommonErrorCode

      def create
        register_type = params[:type]
        unless ALLOW_TYPES.include?(register_type)
          return render_api_error(UNSUPPORTED_TYPE)
        end
        send("register_by_#{register_type}")
      end

      private
      def register_by_mobile
        api_result = register_service.create_user_by_mobile(user_params)
        render_api_user(api_result)
      end

      def register_by_email
        api_result = register_service.create_user_by_email(user_params)
        render_api_user(api_result)
      end

      def render_api_user(api_result)
        if api_result.is_failure?
          render_api_error(api_result.code, api_result.msg)
        else
          template = "v10/account/users/base"
          app_access_token = api_result.data.delete(:app_access_token)
          view_params = {api_result: api_result,
                         user: api_result.data[:user],
                         app_access_token: app_access_token}
          response.headers.merge!('X-Dp-Access-Token' => app_access_token.access_token)
          render template, locals: view_params
        end
      end

      def user_params
        params.permit(:type, :email, :mobile, :password)
      end

      def register_service
        Services::Account::UserService
      end
    end
  end
end
