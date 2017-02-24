module Services
  module Orders
    class OrderDetailService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :order_num

      def initialize(order_num)
        self.order_num = order_num
      end

      def call
        order = PurchaseOrder.find_by_order_number(order_num)
        return ApiResult.error_result(NOT_FOUND) if order.nil?
        order_snapshot = order.snapshot
        data = {
            order_info: order,
            race_info:  order_snapshot
        }
        ApiResult.success_with_data(data)
      end
    end
  end
end
