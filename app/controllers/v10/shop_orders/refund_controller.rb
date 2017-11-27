module V10
  module ShopOrders
    class RefundController < ApplicationController
      def create
        order_item = ProductOrderItem.find(params[:item_id])
        refund_type = ProductRefundType.find(params[:product_refund_type_id])
        result = Services::ShopOrders::CreateRefundService.call(user_params, order_item, refund_type)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/shop_order/refund/create', locals: { refund_record: result.data[:refund_record] }
      end

      private

      def user_params
        params.permit(:product_refund_type_id,
                      :refund_price,
                      :memo,
                      refund_images: [:id, :content])
      end
    end
  end
end

