class ApplicationController < ActionController::API
  protected

  def render_api_error(error_code, msg = nil)
    if error_code.between?(Constants::Error::Http::HTTP_FAILED, Constants::Error::Http::HTTP_MAX)
      head_msg = msg.nil? ? Constants::ERROR_MESSAGES[error_code] : msg
      head error_code, x_dp_msg: head_msg, content_type: 'application/json'
    else
      render 'common/error', locals: { api_result: ApiResult.new(error_code, msg) }
    end
  end

  def render_api_success
    render 'common/error', locals: { api_result: ApiResult.success_result }
  end

  public

  rescue_from(ActiveRecord::RecordNotFound) do
    render_api_error(Constants::Error::Common::NOT_FOUND)
  end
end
