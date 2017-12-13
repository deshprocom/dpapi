module V10
  module Topic
    class VideosController < ApplicationController
      before_action :set_video

      def comments
        @comments = @video.comments.page(params[:page]).per(params[:page_size])
        render :index
      end

      private

      def set_video
        @video = Video.find(params[:id])
      end
    end
  end
end