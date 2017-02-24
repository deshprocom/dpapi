module Services
  module Orders
    class CancelOrderService
      include Serviceable
      include Constants::Error::Order
      attr_accessor :order, :user

      def initialize(order, user)
        self.order = order
        self.user  = user
      end

      def call
        return error_result(CANNOT_CANCEL) unless order.status == 'unpaid'

        user.tickets.find_by(race_id: order.race_id).update(canceled: true)
        order.update(status: 'canceled')
        order.race.return_a_e_ticket
        ApiResult.success_result
      end
    end
  end
end
