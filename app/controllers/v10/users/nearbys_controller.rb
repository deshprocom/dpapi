module V10
  module Users
    class NearbysController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @nearby_users = @current_user.nearbys(500).limit(100)
        render 'index'
      end

      def create
        @current_user.update!(latitude: params[:latitude], longitude: params[:longitude])
        render_api_success
      end
    end
  end
end
