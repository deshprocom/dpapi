module V10
  module Homepage
    class HotInfosController < ApplicationController
      def index
        @hot_infos = HotInfo.default_order
      end
    end
  end
end