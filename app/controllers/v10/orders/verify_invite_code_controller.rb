module V10
  module Orders
    class VerifyInviteCodeController < ApplicationController
      include UserAccessible
      include Constants::Error::Order
      before_action :login_required, :user_self_required
      def create
        # 不存在这样的邀请码
        return render_api_error(INVITE_CODE_NOT_EXIST) unless InviteCode.exists?(code: params[:invite_code])
        render_api_success
      end
    end
  end
end

