module V10
  module ShopOrders
    class ProductOrdersController < ApplicationController
      include UserAccessible
      include Constants::Error::Order
      before_action :login_required

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
