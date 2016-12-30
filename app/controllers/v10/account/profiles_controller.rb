module V10
  module Account
    #个人中心 个人信息部分
    class ProfilesController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def show
        #获取用户信息
        template = 'v10/account/users/base'
        view_params = {
          api_result: ApiResult.success_result,
          user: @current_user
        }
        render template, locals: view_params
      end

      def update
        #修改用户个人信息
      end

      private

      def user_permit_params
        params.permit(:nick_name, :gender, :birthday, :signature)
      end
    end
  end
end

