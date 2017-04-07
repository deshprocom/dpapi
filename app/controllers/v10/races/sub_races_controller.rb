module V10
  module Races
    class SubRacesController < ApplicationController
      before_action :set_race

      def index
        render 'index'
      end

      def set_race
        @race = Race.find(params[:race_id])
      end
    end
  end
end
