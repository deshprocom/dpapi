module Services
  module Notify
    class WxNotifyService
      include Serviceable
      attr_accessor :order_result

      def initialize(order_result)
        self.order_result = order_result
      end

      def call
        # 判断请求是否成功
        return api_result('FAIL', '请求不成功') unless success?(order_result)

        # 返回的请求成功 验证签名
        return api_result('FAIL', '签名失败') unless sign_success?(order_result)

        # 检查订单是否存在，订单的金额是否和数据库一致
        return api_result('FAIL', '订单不存在或订单金额不匹配') unless check_order(order_result)

        # 更改订单的状态为已支付
        # TODO change_order_status(order_result)

        # 记录交易日志
        # TODO create_bill

        # 返回商户操作成功通知
        api_result('SUCCESS', 'OK')
      end

      private

      def success?(result)
        result['return_code'].eql?('SUCCESS') && result['result_code'].eql?('SUCCESS')
      end

      def sign_success?(result)
        WxPay::Sign.verify?(result)
      end

      def check_order(result)
        order = order_info(result)
        order.present? && order.price.eql?(result['total_fee'])
      end

      def change_order_status(result)
        order = order_info(result)
        order.paid! if order.present? && order.unpaid?
      end

      def order_info(result)
        order_number = result['out_trade_no']
        PurchaseOrder.find_by(order_number: order_number)
      end

      def api_result(code, msg)
        {
          return_code: code,
          return_msg: msg
        }
      end
    end
  end
end