module V10
  module Races
    class OrdersController < ApplicationController
      include Constants::Error::Common
      include UserAccessible

      before_action :set_race, :login_required

      def new_order
        @user = @current_user
        render 'new_order'
      end

      private

      def set_race
        @race = Race.find(params[:race_id])
      end
    end
  end
end
