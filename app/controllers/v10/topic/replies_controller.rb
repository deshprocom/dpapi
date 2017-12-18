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
        result = Services::UserAuthCheck.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        result = Services::Replies::CreateReplyService.call(user_params, @current_user, @comment)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'create', locals: { reply: result.data[:reply] }
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

      def user_params
        params.permit(:body)
      end
    end
  end
end
