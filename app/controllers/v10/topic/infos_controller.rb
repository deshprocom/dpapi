module V10
  module Topic
    class InfosController < ApplicationController
      before_action :set_info
      include UserAccessible
      before_action :login_required, only: [:likes, :dislikes]
      include Constants::Error::Account

      def comments
        @comments = @info.comments.page(params[:page]).per(params[:page_size])
        render :index
      end

      def likes
        return render_api_error(USER_BLOCKED) if @current_user.blocked?
        @current_user.topic_likes.create(topic: @info)
        @info.increase_likes
        render_api_success
      end

      def dislikes
        return render_api_error(USER_BLOCKED) if @current_user.blocked?
        @current_user.topic_likes.where(topic: @info).destroy
        @info.decrease_likes
        render_api_success
      end

      private

      def set_info
        @info = Info.find(params[:id])
      end
    end
  end
end

