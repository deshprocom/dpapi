module V10
  module Users
    class DynamicsController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @dynamics = @current_user.dynamics
                                 .order(created_at: :desc)
                                 .page(params[:page])
                                 .per(params[:page_size])
      end
    end
  end
end

