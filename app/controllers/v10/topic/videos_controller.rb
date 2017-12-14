module V10
  module Topic
    class VideosController < ApplicationController
      before_action :set_video
      include UserAccessible
      before_action :login_required, only: [:likes, :dislikes]
      include Constants::Error::Account

      def comments
        @comments = @video.comments.page(params[:page]).per(params[:page_size])
        render :index
      end

      def likes
        return render_api_error(USER_BLOCKED) if @current_user.blocked?
        # 查看该话题用户是否点过赞
        topic = @current_user.topic_likes.find_by(topic: @video)
        if topic.blank?
          @current_user.topic_likes.create(topic: @video)
          @video.increase_likes
        else
          topic.destroy!
          @video.decrease_likes
        end
        render_api_success
      end

      private

      def set_video
        @video = Video.find(params[:id])
      end
    end
  end
end