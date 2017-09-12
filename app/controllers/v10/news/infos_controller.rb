module V10
  module News
    class InfosController < ApplicationController
      def show
        @info = Info.find(params[:id])
      end
    end
  end
end

