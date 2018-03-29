module V10
  module Topic
    class UserTopicsController < ApplicationController
      before_action :set_user_topic
      include UserAccessible
      before_action :login_required, only: [:likes]

      def comments
        @comments = @user_topic.comments.order_show.page(params[:page]).per(params[:page_size])
      end

      def likes
        result = Services::Topic::CreateLikes.call(@user_topic, @current_user)
        return render_api_error(result.code, result.msg) if result.failure?
        render 'v10/topic/likes', locals: { topic: @user_topic }
      end

      private

      def set_user_topic
        @user_topic = UserTopic.find(params[:id])
      end
    end
  end
end

