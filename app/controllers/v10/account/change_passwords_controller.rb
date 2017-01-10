module V10
  module Account
    # 修改密码
    class ChangePasswordsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        change_pwd_service = Services::Account::ChangePasswordService
        api_result = change_pwd_service.call(user_params[:new_pwd], user_params[:old_pwd], @current_user)
        render_api_result api_result
      end

      private

      def user_params
        params.permit(:new_pwd, :old_pwd)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?
        render_api_success
      end
    end
  end
end
