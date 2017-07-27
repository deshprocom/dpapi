module V10
  module Users
    class FollowedPlayersController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        optional! :page_size, values: 0..100, default: 20
        optional! :page_index, default: 0
        offset = params[:page_size].to_i * params[:page_index].to_i
        @followed_players = @current_user.followed_players.offset(offset).limit(params[:page_size])
      end
    end
  end
end
