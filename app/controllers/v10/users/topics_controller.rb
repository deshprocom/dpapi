module V10
  module Users
    class TopicsController < ApplicationController
      def index
        @topics = UserTopic.undeleted.sorted.page(params[:page]).per(params[:page_size])
      end

      def recommends
        @topics = UserTopic.undeleted.recommended.sorted.page(params[:page]).per(params[:page_size])
      end

      def details
        @topic = UserTopic.find(params[:id])
        @topic.increase_page_views
      end
    end
  end
end

