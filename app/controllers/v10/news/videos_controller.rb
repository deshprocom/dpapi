module V10
  module News
    class VideosController < ApplicationController
      def show
        @video = Video.find(params[:id])
      end
    end
  end
end

