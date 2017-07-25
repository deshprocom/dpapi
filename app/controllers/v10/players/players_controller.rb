module V10
  module Players
    # 牌手信息部分
    class PlayersController < ApplicationController
      include Constants::Error::Common

      def index
        @players = Player.limit(20)
      end

      def show
        @player = Player.find_by!(player_id: params[:id])
      end
    end
  end
end

