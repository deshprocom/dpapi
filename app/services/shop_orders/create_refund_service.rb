module Services
  module ShopOrders
    class CreateRefundService
      include Serviceable
      include Constants::Error::Order

      def initialize(params, order_items, refund_type, order)
        @params = params
        @order = order
        @order_items = order_items
        @refund_type = refund_type
      end

      def call
        return ApiResult.error_result(REFUND_ALREADY_EXIST) if refund_exists?
        return ApiResult.error_result(CANNOT_REFUND) unless seven_days_return?
        return ApiResult.error_result(INVALID_REFUND_PRICE) unless refund_price_valid?
        refund_record = create_refund
        create_detail(refund_record)
        create_refund_images(refund_record)
        @order_items.each(&:refunded!)
        ApiResult.success_with_data(refund_record: refund_record)
      end

      private

      def create_refund
        ProductRefund.create(product_order: @order,
                             product_refund_type: @refund_type,
                             refund_price: @params[:refund_price],
                             memo: @params[:memo])
      end

      def create_detail(refund_record)
        @order_items.each do |item|
          refund_record.product_refund_details.create(product_order_item: item)
        end
      end

      def create_refund_images(refund_record)
        @params[:refund_images].each do |item|
          temp_image = TmpImage.find_by(id: item[:id])
          next if temp_image.blank?
          ProductRefundImage.create(product_refund: refund_record, remote_image_url: temp_image.image_path, memo: item[:content])
          remove_tmp_image(temp_image)
        end
      end

      def seven_days_return?
        # 只要有一个不是7天退换货，就返回false
        !@order_items.pluck(:seven_days_return).include?(false)
      end

      def refund_exists?
        # 如果有一个商品已经退款中，那么不可退款
        @order_items.pluck(:refunded).include?(true)
      end

      def refund_price_valid?
        total_item_price = 0
        @order_items.each do |item|
          total_item_price += item.price * item.number
        end
        max_price = total_item_price + @order.shipping_price
        @params[:refund_price].is_a?(Numeric) && @params[:refund_price].positive? &&
          @params[:refund_price] <= max_price
      end

      def remove_tmp_image(image)
        image.destroy!
      end
    end
  end
end