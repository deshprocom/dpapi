module Services
  module Orders
    class PayBillService
      include Serviceable
      attr_accessor :send_params

      def initialize(send_params)
        self.send_params = send_params
      end

      def call
        change_order_status(send_params[:MerchOrderId])
        bill = Bill.new(create_params(send_params))
        bill.save!
      end

      private

      def create_params(resource)
        { merchant_id: resource[:MerchantId],
          order_number: resource[:MerchOrderId],
          amount: resource[:Amount],
          pay_time: resource[:PayTime],
          trade_number: resource[:OrderId],
          trade_code: resource[:Status],
          trade_status: 'paid',
          trade_msg: '交易成功' }
      end

      def change_order_status(number)
        order = PurchaseOrder.find_by!(order_number: number)
        order.paid! if order.unpaid?
      end
    end
  end
end
