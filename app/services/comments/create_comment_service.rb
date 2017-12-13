module Services
  module Comments
    class CreateCommentService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Comment

      def initialize(params, user)
        @params = params
        @user = user
      end

      def call
        return ApiResult.error_result(UNSUPPORTED_TYPE) unless topic_type_permit?
        return ApiResult.error_result(BODY_ERROR) unless comment_body_permit?
        comment = @user.comments.create(topic: get_topic, body: @params[:body])
        ApiResult.success_with_data(comment: comment)
      end

      private

      def topic_type_permit?
        %w(info video).include?(@params[:topic_type])
      end

      def comment_body_permit?
        @params[:body].to_s.strip.length.positive?
      end

      def get_topic
        send("get_#{@params[:topic_type]}")
      end

      def get_info
        Info.find(@params[:topic_id])
      end

      def get_video
        Video.find(@params[:topic_id])
      end
    end
  end
end
