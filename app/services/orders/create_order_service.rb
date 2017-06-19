module Services
  module Orders
    class CreateOrderService
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
      cattr_accessor :lock_retry_times
      self.lock_retry_times = 2
      delegate :ticket_info, to: :@ticket

      def initialize(race, ticket, user, params)
        @race   = race
        @ticket = ticket
        @user   = user
        @params = params
      end

      def call
        unless @params[:ticket_type].in? TICKET_TYPES
          return ApiResult.error_result(UNSUPPORTED_TYPE)
        end

        unless @race.ticket_sellable
          return ApiResult.error_result(TICKET_NO_SELL)
        end

        unless @ticket.status == 'selling'
          return ApiResult.error_result(TICKET_STATUS_ERRORS[@ticket.status.to_sym])
        end

        return ApiResult.error_result(NO_CERTIFICATION) unless @user.user_extra

        ##
        # 放开购买次数限制
        # if PurchaseOrder.purchased?(@user.id, @race.id)
        #   return ApiResult.error_result(AGAIN_BUY)
        # end

        send("ordering_#{@params[:ticket_type]}")
      end

      def ordering_e_ticket
        unless UserValidator.email_valid?(@params[:email])
          return ApiResult.error_result(PARAM_FORMAT_ERROR)
        end

        result = stale_ticket_info_retries { sold_a_e_ticket }
        return result if result.failure?

        id_status_to_pending
        order = PurchaseOrder.new(email_order_params)
        return ApiResult.success_with_data(order: order) if order.save

        ApiResult.error_result(SYSTEM_ERROR)
      end

      def stale_ticket_info_retries
        optimistic_lock_retry_times = self.class.lock_retry_times
        begin
          yield
        rescue ActiveRecord::StaleObjectError
          optimistic_lock_retry_times -= 1
          return ApiResult.error_result(SYSTEM_ERROR) if optimistic_lock_retry_times.negative?

          ticket_info.reload(lock: true)
          retry
        end
      end

      def sold_a_e_ticket
        if ticket_info.e_ticket_sold_out?
          return ApiResult.error_result(E_TICKET_SOLD_OUT)
        end

        ticket_info.increment_with_lock!(:e_ticket_sold_number)
        @ticket.update(status: 'sold_out') if ticket_info.sold_out?
        ApiResult.success_result
      end

      def id_status_to_pending
        @user.user_extra.update(status: 'pending') if @user.user_extra.status == 'init'
      end

      def ticket_params
        {
          user_id:         @user.id,
          ticket_infos_id: ticket_info.id,
          race_id:         @race.id,
          ticket_type:     @params[:ticket_type]
        }
      end

      def init_order_params
        {
          user:           @user,
          race:           @race,
          ticket:         @ticket,
          price:          @ticket.price,
          original_price: @ticket.original_price,
          ticket_type:    @params[:ticket_type],
          status:         'unpaid'
        }
      end

      def email_order_params
        init_order_params.merge(email: @params[:email])
      end
    end
  end
end
