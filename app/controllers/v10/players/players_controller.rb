module V10
  module Players
    # 牌手信息部分
    class PlayersController < ApplicationController
      include Constants::Error::Common

      def show
        player = Player.find_by(player_id: params[:id])
        return render_api_error(NOT_FOUND) if player.blank?
        template = 'v10/players/player'
        render template, locals: { api_result: ApiResult.success_result,
                                   player: player }
      end
    end
  end
end

