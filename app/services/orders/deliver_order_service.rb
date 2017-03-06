module Services
  module Orders
    class DeliverOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order_number

      def initialize(order_number)
        self.order_number = order_number
      end

      def call
        order = PurchaseOrder.find_by(order_number: order_number)
        return unless order.status == 'paid'

        order.update(status: 'completed')
        ApiResult.success_result
      end
    end
  end
end
