module V10
  module Races
    class OrdersController < ApplicationController
      include UserAccessible

      before_action :set_race, :set_ticket, :login_required

      def new_order
        @user = @current_user
        return render_api_error(NOT_FOUND) unless @race.ticket.ticket_info

        render 'new_order'
      end

      def create
        result = Services::Orders::CreateOrderService.call(@race, @ticket, @current_user, params)
        return render_api_error(result.code, result.msg) if result.failure?

        @order = result.data[:order]
        result = Services::Orders::PayOrderService.call(@order.order_number)
        return render_api_error(result.code, result.msg) if result.failure?

        @pay_url = result.data[:pay_result]['body'].to_s
        render 'pay_order'
      end

      private

      def set_race
        @race = Race.find(params[:race_id])
      end

      def set_ticket
        @ticket = Ticket.find(params[:ticket_id])
      end
    end
  end
end
