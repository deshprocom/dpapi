module V10
  module News
    class InfosController < ApplicationController
      def show
        @info = Info.find(params[:id])
        @info.increase_page_views
      end
    end
  end
end

