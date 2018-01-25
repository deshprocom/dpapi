module V10
  module Cf
    class CrowdfundingOrdersController < ApplicationController
      include UserAccessible
      before_action :login_required
      include Constants::Error::Common

      def index
        orders = @current_user.crowdfunding_orders
        if CrowdfundingOrder.record_statuses.keys.include?(params[:status])
          orders = orders.where(record_status: params[:status])
        end
        @orders = orders.page(params[:page]).per(params[:page_size])
        render :index
      end

      def create
        return render_api_error(MISSING_PARAMETER) if params[:number].to_i <= 0
        cf_player = CrowdfundingPlayer.find(params[:cf_player_id])
        result = Services::CrowdfundingOrders::CreateService.call(@current_user, cf_player, params[:number])
        return render_api_error(result.code, result.msg) if result.failure?
        render :create, locals: { order: result.data[:order] }
      end

      def show
        @order = CrowdfundingOrder.find_by!(order_number: params[:id])
      end

      def destroy
        @order = CrowdfundingOrder.find_by!(order_number: params[:id])
        @order.deleted!
        render_api_success
      end
    end
  end
end

