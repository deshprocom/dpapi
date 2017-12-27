module V10
  module Homepage
    class HotInfosController < ApplicationController
      def index
        per = params[:page_size] ? params[:page_size] : 50
        @hot_infos = HotInfo.default_order.page(params[:page]).per(per)
      end
    end
  end
end