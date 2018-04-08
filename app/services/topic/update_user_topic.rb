module Services
  module Topic
    class UpdateUserTopic
      include Serviceable
      include Constants::Error::Account
      include Constants::Error::Common
      include Constants::Error::Topic

      def initialize(topic, params)
        @topic = topic
        @params = params
      end

      def call
        # 判断话题是否支持更新操作
        return ApiResult.error_result(CANNOT_UPDATE) unless @topic.draft?

        @topic.assign_attributes(init_update_params)
        @topic.updated_at = Time.zone.now
        ApiResult.success_with_data(user_topic: @topic)
      end

      def init_update_params
        {
          body: @params[:body],
          title: @params[:title],
          cover_link: @params[:cover_link],
          published: @params[:published],
          lat: @params[:lat],
          lng: @params[:lng],
          location: @params[:location]
        }
      end
    end
  end
end
