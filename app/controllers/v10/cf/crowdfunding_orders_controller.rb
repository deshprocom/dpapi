module V10
  module Cf
    class CrowdfundingOrdersController < ApplicationController
      include UserAccessible
      before_action :login_required
      include Constants::Error::Common

      def create
        return render_api_error(MISSING_PARAMETER) if params[:number].to_i <= 0
        cf_player = CrowdfundingPlayer.find(params[:cf_player_id])
        result = Services::CrowdfundingOrders::CreateService.call(@current_user, cf_player, params[:number])
        return render_api_error(result.code, result.msg) if result.failure?
        render :create, locals: { order: result.data[:order] }
      end
    end
  end
end

