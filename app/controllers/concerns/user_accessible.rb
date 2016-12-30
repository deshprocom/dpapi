module UserAccessible
  extend ActiveSupport::Concern

  #检查用户是否登录
  def login_required
    user_uuid = CurrentRequestCredential.current_user_id
    @current_user = User.by_uuid(user_uuid) unless user_uuid.nil?
    #找不到该用户，未登录
    if @current_user.blank?
      render_api_error(Constants::Error::Http::HTTP_LOGIN_REQUIRED)
    end
  end

  #判断需要操作的用户是否是自己
  def user_self_required
    unless @current_user.present? && @current_user.user_uuid.eql?(params[:user_id])
      render_api_error(Constants::Error::Http::HTTP_ACCESS_FORBIDDEN)
    end
  end
end
