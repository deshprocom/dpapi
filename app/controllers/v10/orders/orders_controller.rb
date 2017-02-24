module V10
  module Orders
    class OrdersController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        order_list_service = Services::Orders::OrderListService
        result = order_list_service.call(user_params[:page_size], user_params[:next_id], @current_user)
        template = 'v10/orders/index'
        render template, locals: { api_result:  result,
                                   order_lists: result.data[:order_lists],
                                   next_id:     result.data[:next_id] }
      end

      def show
        order_detail_service = Services::Orders::OrderDetailService
        result = order_detail_service.call(params[:id])

        return render_api_error(result.code, result.msg) if result.failure?
        template = 'v10/orders/show'
        render template, locals: { api_result:         result,
                                   order_info:         result.data[:order_info],
                                   race_info:          result.data[:race_info] }
      end

      private

      def user_params
        params.permit(:page_size,
                      :next_id)
      end
    end
  end
end
