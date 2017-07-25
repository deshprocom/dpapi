module V10
  class LoginCountController < ApplicationController
    include UserAccessible
    before_action :login_required, :user_self_required

    def create
      # 访问次数加1
      User.increment_counter(:login_count, @current_user.id)
      render_api_success
    end
  end
end

