module V10
  module ShopOrders
    class ProductOrdersController < ApplicationController
      include UserAccessible
      include Constants::Error::Order
      before_action :login_required
      before_action :set_order, only: [:wx_paid_result]

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

      def wx_paid_result
        result = WxPay::Service.order_query(out_trade_no: @order.order_number)
        unless result['trade_state'] == 'SUCCESS'
          return render_api_error(INVALID_ORDER, result['trade_state_desc'] || result['err_code_des'])
        end
        api_result = Services::Notify::WxShopNotifyNotifyService.call(result[:raw]['xml'])

        return render_api_error(INVALID_ORDER, api_result.msg) if api_result.failure?

        render_api_success
      end

      private

      def set_order
        @order = @current_user.product_orders.find_by!(order_number: params[:id])
      end
    end
  end
end
