module V10
  module Races
    class TicketsController < ApplicationController
      include UserAccessible
      before_action :current_user
      before_action :set_race, only: [:index, :preferential]
      before_action :set_tickets, only: [:show]

      # 选票页面所需数据
      def index
        return @tickets = @race.tickets.tradable if @current_user&.tester?

        @tickets = @race.tickets.tradable.everyone
      end

      # 购票页面所需数据
      def show
        render_api_error(NOT_FOUND) unless @ticket.ticket_info
      end

      private

      def set_race
        @race = Race.find(params[:race_id])
      end

      def set_tickets
        @ticket = Ticket.find(params[:id])
      end
    end
  end
end
