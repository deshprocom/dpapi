module V10
  module Orders
    class VerifyInviteCodeController < ApplicationController
      include UserAccessible
      include Constants::Error::Order
      before_action :login_required, :user_self_required
      def create
        invite_code = params[:invite_code]&.strip&.upcase
        # 不存在这样的邀请码
        return render_api_error(INVITE_CODE_NOT_EXIST) unless InviteCode.exists?(code: invite_code)
        render_api_success
      end
    end
  end
end

