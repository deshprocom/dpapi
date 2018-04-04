module V10
  module Users
    class JmessageController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def create
        jmessage_service = Services::Jmessage::CreateUser
        result = jmessage_service.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render :create, locals: { j_user: result.data[:j_user] }
      end
    end
  end
end

