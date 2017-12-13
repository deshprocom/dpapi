module V10
  module Topic
    class RepliesController < ApplicationController
      include UserAccessible
      include Constants::Error::Comment
      before_action :login_required, only: [:create, :destroy]
      before_action :set_comment, only: [:create, :destroy]
      before_action :set_reply, only: [:destroy]

      def index
        comment = Comment.find(params[:comment_id])
        @replies = comment.replies
        render :index
      end

      def create
        return render_api_error(BODY_ERROR) unless params[:body].to_s.strip.length.positive?
        @reply = @comment.replies.create!(user: @current_user, body: params[:body])
        render :create
      end

      def destroy
        @reply.destroy
        render_api_success
      end

      private

      def set_comment
        @comment = @current_user.comments.find_by!(id: params[:comment_id])
      end

      def set_reply
        @reply = @comment.replies.find_by!(id: params[:id])
      end
    end
  end
end
