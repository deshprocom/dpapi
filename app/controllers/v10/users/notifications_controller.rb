module V10
  class NotificationsController < ApplicationController
    include UserAccessible
    before_action :login_required, :user_self_required

    def index; end
  end
end
