module V10
  module Orders
    class OrdersController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        optional! :page_size, values: 0..100, default: 10
        optional! :status, default: 'all'
        params[:next_id] = 10**15 if params[:next_id].to_i.zero?
        @orders = @current_user.orders.where('order_number < ?', params[:next_id])
                               .limit(params[:page_size])
                               .order(order_number: :desc)
        if PurchaseOrder.statuses.keys.include?(params[:status])
          @orders = @orders.where(status: params[:status])
        end
        @orders = @orders.includes(:ticket, :snapshot)
      end

      def show
        @order = @current_user.orders.find_by!(order_number: params[:id])
      end

      private

      def user_params
        params.permit(:page_size,
                      :next_id,
                      :status)
      end
    end
  end
end
