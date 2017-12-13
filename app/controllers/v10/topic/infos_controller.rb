module V10
  module Topic
    class InfosController < ApplicationController
      before_action :set_info

      def comments
        @comments = @info.comments.page(params[:page]).per(params[:page_size])
        render :index
      end

      private

      def set_info
        @info = Info.find(params[:id])
      end
    end
  end
end

