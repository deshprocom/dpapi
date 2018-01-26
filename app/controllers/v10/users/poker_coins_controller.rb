module V10
  module Users
    class PokerCoinsController < ApplicationController
      include UserAccessible
      before_action :login_required

      def index
        @poker_coins = @current_user.poker_coins.page(params[:page]).per(params[:page_size])
      end
    end
  end
end

