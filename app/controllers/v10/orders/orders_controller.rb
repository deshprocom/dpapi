module V10
  module Orders
    class OrdersController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        order_list_service = Services::Orders::OrderListService
        result = order_list_service.call(user_params[:page_size], user_params[:next_id], @current_user)
        template = 'v10/orders/index'
        RenderResultHelper.render_order_result(self, template, result)
      end

      private

      def user_params
        params.permit(:page_size,
                      :next_id)
      end
    end
  end
end
