module V10
  module Races
    class TicketsController < ApplicationController
      before_action :set_race, only: [:index]
      before_action :set_tickets, only: [:show]

      # 选票页面所需数据
      def index; end

      # 购票页面所需数据
      def show
        return render_api_error(NOT_FOUND) unless @ticket.ticket_info

        render 'new_order'
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
