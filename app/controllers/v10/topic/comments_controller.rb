module V10
  module Topic
    class CommentsController < ApplicationController
      include UserAccessible
      before_action :login_required
      before_action :set_comment, only: [:destroy]

      def create
        result = Services::Comments::CreateCommentService.call(user_params, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'index', locals: { comment: result.data[:comment] }
      end

      def destroy
        @comment.destroy
        render_api_success
      end

      private

      def user_params
        params.permit(:topic_type,
                      :topic_id,
                      :body)
      end

      def set_comment
        @comment = @current_user.comments.find_by!(id: params[:id])
      end
    end
  end
end

