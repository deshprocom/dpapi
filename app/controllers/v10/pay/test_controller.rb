module V10
  module Pay
    class TestController < ApplicationController
      def index
        params = {
          amount: 1.11,
          order_desc: 'MBP希望杯',
          client_ip: CurrentRequestCredential.client_ip,
          merch_order_id: '2017073100002',
          trade_time: trade_time
        }
        @result = JSON.parse(YlPay::Service.generate_order_url(params))
        template = 'v10/pay/test.json'
        render template
      end

      private

      def order_id
        '1220170808' + rand(100..999).to_s
      end

      def trade_time
        Time.now.strftime('%Y%m%d%H%M%S')
      end
    end
  end
end

