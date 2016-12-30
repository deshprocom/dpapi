module V10
  module Account
    # 生成需要渲染出去的数据
    class RenderResultHelper < ApplicationController
      def self.base_user_result(current_user)
        {
          api_result: ApiResult.success_result,
          user: current_user
        }
      end

      def self.session_user_result(result)
        app_access_token = result.data.delete(:app_access_token)
        {
          api_result: result,
          user: result.data[:user],
          app_access_token: app_access_token
        }
      end
    end
  end
end
