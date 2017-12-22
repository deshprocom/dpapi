module V10
  module Topic
    class RepliesController < ApplicationController
      include UserAccessible
      before_action :login_required, only: [:create, :destroy]
      before_action :set_comment, only: [:destroy]
      before_action :set_reply, only: [:destroy]

      def index
        comment = Comment.find(params[:comment_id])
        @replies = comment.replies
        render :index
      end

      def create
        result = Services::UserAuthCheck.call(@current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        @comment = Comment.find(params[:comment_id])
        result = params[:reply_id].present? ? parent_reply : parent_comment
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
        reply_id = params[:id] || params[:reply_id]
        @reply = @comment.replies.find_by!(id: reply_id)
      end

      def user_params
        params.permit(:body)
      end

      def parent_comment
        Services::Replies::CreateReplyService.call(user_params, @current_user, @comment)
      end

      def parent_reply
        Services::Replies::CreateReplyService.call(user_params, @current_user, @comment, set_reply)
      end
    end
  end
end
