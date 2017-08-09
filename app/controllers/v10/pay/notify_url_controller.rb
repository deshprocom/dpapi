module V10
  module Pay
    class NotifyUrlController < ApplicationController
      def create
hui        bill = Bill.new(create_params(permit_params))
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

      def permit_params
        params.permit(:Version,
                      :MerchantId,
                      :MerchOrderId,
                      :Amount,
                      :ExtData,
                      :OrderId,
                      :Status,
                      :PayTime,
                      :SettleDate,
                      :Sign)
      end
    end
  end
end

