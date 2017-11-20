module V10
  module ShopOrders
    class ProductOrdersController < ApplicationController
      include UserAccessible
      include Constants::Error::Order
      before_action :login_required

      def index
        page_size = params[:page_size].blank? ? '10' : params[:page_size]
        next_id = params[:next_id].to_i <= 0 ? 1 : params[:next_id].to_i
        orders = @current_user.product_orders.order(created_at: :desc).page(next_id).per(page_size)
        next_id += 1
        template = 'v10/shop_order/product_orders/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   orders: orders,
                                   next_id: next_id }
      end

      def new
        shipping_info = params[:shipping_info] || {}
        province = shipping_info[:address] && shipping_info[:address][:province]
        @pre_purchase_items = Services::ShopOrders::PrePurchaseItems.new(params[:variants], province)
        if @pre_purchase_items.check_result != 'ok'
          return render_api_error(INVALID_ORDER, @pre_purchase_items.check_result)
        end
        render 'v10/shop_order/product_orders/new'
      end

      def create
        result = Services::ShopOrders::CreateOrderService.call(@current_user, params)
        return render_api_error(result.code, result.msg) if result.failure?

        render 'v10/shop_order/product_orders/create', locals: { order: result.data[:order] }
      end
    end
  end
end
