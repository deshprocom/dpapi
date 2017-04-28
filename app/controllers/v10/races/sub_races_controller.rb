module V10
  module Races
    class SubRacesController < ApplicationController
      before_action :set_race, only: [:index]

      def index; end

      def show
        @sub_race = Race.find(params[:id])
      end

      def set_race
        @race = Race.find(params[:race_id])
      end
    end
  end
end
