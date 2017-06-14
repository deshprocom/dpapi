module V10
  class NotificationsController < ApplicationController
    include UserAccessible
    before_action :login_required, :user_self_required

    def index
      @notifications = @current_user.notifications.order(id: :desc).limit(30)
    end

    def destroy
      @current_user.notifications.find(params[:id]).destroy
      render_api_success
    end
  end
end
