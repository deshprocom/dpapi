module Services
  module ShopOrders
    class CreateRefundService
      include Serviceable
      include Constants::Error::Order

      def initialize(params, order_item, refund_type)
        @params = params
        @order_item = order_item
        @refund_type = refund_type
      end

      def call
        return ApiResult.error_result(REFUND_ALREADY_EXIST) unless @order_item.refund_record_permit?
        return ApiResult.error_result(CANNOT_REFUND) unless @order_item.seven_days_return
        return ApiResult.error_result(INVALID_REFUND_PRICE) unless refund_price_valid?
        refund_record = create_refund
        @order_item.refunded!
        create_refund_images(refund_record)
        ApiResult.success_with_data(refund_record: refund_record)
      end

      private

      def create_refund
        ProductRefund.create(product_order_item: @order_item,
                             product_refund_type: @refund_type,
                             refund_price: @params[:refund_price],
                             memo: @params[:memo])
      end

      def create_refund_images(refund_record)
        @params[:refund_images].each do |item|
          temp_image = TmpImage.find_by(id: item[:id])
          next if temp_image.blank?
          ProductRefundImage.create(product_refund: refund_record, image: temp_image.image, memo: item[:content])
          remove_tmp_image(temp_image)
        end
      end

      def refund_price_valid?
        @params[:refund_price] <= @order_item.original_price
      end

      def remove_tmp_image(image)
        image.destroy!
      end
    end
  end
end