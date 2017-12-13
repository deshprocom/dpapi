module V10
  module Topic
    class RepliesController < ApplicationController
      include UserAccessible
      before_action :login_required
      include Constants::Error::Comment

      def create
        comments = Comment.find(params[:comment_id])
        return render_api_error(BODY_ERROR) unless params[:body].to_s.strip.length.positive?
        @reply = comments.replies.create!(user: @current_user, body: params[:body])
        render :index
      end
    end
  end
end
