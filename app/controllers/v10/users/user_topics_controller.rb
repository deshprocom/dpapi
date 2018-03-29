module V10
  module Users
    class UserTopicsController < ApplicationController
      include Constants::Error::Common
      include Constants::Error::Topic
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        @topics = @current_user.user_topics.undeleted.sorted.page(params[:page]).per(params[:page_size])
      end

      def create
        return render_api_error(MISSING_PARAMETER) if params_blank?
        return render_api_error(UNSUPPORTED_TYPE) unless body_type_valid?
        return render_api_error(TITLE_BLANK) if title_blank?
        user_topic_service = Services::Topic::CreateUserTopic
        api_result = user_topic_service.call(@current_user, params)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?

        render 'create', locals: { user_topic: api_result.data[:user_topic] }
      end

      def destroy
        @topic = @current_user.user_topics.find(params[:id]).destroy
        render_api_success
      end

      private

      def params_blank?
        params[:body_type].blank? ||
          params[:body].blank? ||
          ![true, false].include?(params[:published])
      end

      def title_blank?
        params[:body_type].eql?('long') && params[:title]&.lstrip.blank?
      end

      def body_type_valid?
        %w(short long).include?(params[:body_type])
      end
    end
  end
end
