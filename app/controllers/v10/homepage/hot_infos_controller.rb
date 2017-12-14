module V10
  module Homepage
    class HotInfosController < ApplicationController
      def index
        @hot_infos = HotInfo.default_order.page(params[:page]).per(params[:page_size])
      end
    end
  end
end