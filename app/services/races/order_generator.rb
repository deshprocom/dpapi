module Services
  module Races
    class OrderGenerator
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Race
      include Constants::Error::Account

      TICKET_TYPES = %w(e_ticket entity_ticket).freeze
      TICKET_STATUS_ERRORS = {
        unsold: TICKET_UNSOLD,
        end: TICKET_END,
        sold_out: TICKET_SOLD_OUT
      }.freeze
      attr_accessor :race, :user, :params
      def initialize(race, user, params)
        self.race   = race
        self.user   = user
        self.params = params
      end

      def call
        unless params[:ticket_type].in? TICKET_TYPES
          return ApiResult.error_result(UNSUPPORTED_TYPE)
        end

        unless race.ticket_status == 'selling'
          return ApiResult.error_result(TICKET_STATUS_ERRORS[race.ticket_status.to_sym])
        end

        return ApiResult.error_result(NO_CERTIFICATION) unless user.user_extra

        if Ticket.again_buy?(user.id, race.id)
          return ApiResult.error_result(AGAIN_BUY)
        end

        send("ordering_#{params[:ticket_type]}")
      end

      def ordering_e_ticket
        unless UserValidator.email_valid?(params[:email])
          return ApiResult.error_result(PARAM_FORMAT_ERROR)
        end

        if race.ticket_info.e_ticket_sold_out?
          return ApiResult.error_result(E_TICKET_SOLD_OUT)
        end

        @ticket = Ticket.create(ticket_params)
        PurchaseOrder.create(email_order_params)
        race.ticket_info.e_ticket_sold_increase
        refresh_ticket_status
        ApiResult.success_result
      end

      def refresh_ticket_status
        race.ticket_info.reload
        race.update(ticket_status: 'sold_out') if race.ticket_info.sold_out?
      end

      def ticket_params
        {
          user_id:         user.id,
          cert_type:       user.user_extra.cert_type,
          cert_no:         user.user_extra.cert_no,
          ticket_infos_id: race.ticket_info.id,
          race_id:         race.id,
          ticket_type:     params[:ticket_type],
          status:          'unpaid'
        }
      end

      def init_order_params
        {
          user_id: user.id,
          ticket_id: @ticket.id,
          ticket_type: params[:ticket_type],
          status: 'unpaid'
        }
      end

      def email_order_params
        init_order_params.merge(email: params[:email])
      end
    end
  end
end
