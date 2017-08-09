module V10
  module Pay
    class NotifyUrlController < ApplicationController
      def index
        Rails.logger.info 'test'
        Rails.logger.info permit_params[:Version]
        Rails.logger.info permit_params[:MerchantId]

        render plain: 'test'
      end

      private

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

