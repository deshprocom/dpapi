module V10
  module ShopOrders
    class RefundController < ApplicationController
      def create
        order_item = ProductOrderItem.find(params[:item_id])
        refund_type = ProductRefundType.find(params[:product_refund_type_id])
        result = Services::ShopOrders::CreateRefundService.call(user_params, order_item, refund_type)
        render plain: result.inspect
      end

      private

      def user_params
        params.permit(:product_refund_type_id, :refund_price, :memo, :refund_images)
      end
    end
  end
end

