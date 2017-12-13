module V10
  module Topic
    class CommentsController < ApplicationController
      include UserAccessible
      before_action :login_required

      def create
        result = Services::Comments::CreateCommentService.call(user_params, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'index', locals: { comment: result.data[:comment] }
      end

      private

      def user_params
        params.permit(:topic_type,
                      :topic_id,
                      :body)
      end
    end
  end
end

