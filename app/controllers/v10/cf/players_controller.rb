module V10
  module Cf
    class PlayersController < ApplicationController
      before_action :set_crowdfunding

      def index
        @players = @crowdfunding.crowdfunding_players.published.sorted.page(params[:page]).per(params[:page_size])
      end

      def show
        @player = @crowdfunding.crowdfunding_players.published.find(params[:id])
      end

      private

      def set_crowdfunding
        @crowdfunding = Crowdfunding.find(params[:crowdfunding_id])
      end
    end
  end
end

