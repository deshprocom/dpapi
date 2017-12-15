module V10
  module News
    class VideosController < ApplicationController
      def show
        @video = Video.find(params[:id])
        @video.increase_page_views
      end
    end
  end
end

