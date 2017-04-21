module Services
  module Races
    class SearchByDateService
      include Serviceable
      include Constants::Error::Common

      def initialize(user_uuid, search_params)
        @host_id   = search_params[:host_id].to_i
        @page_size = search_params[:page_size].to_i
        @next_id   = search_params[:next_id].to_i
        @date      = search_params[:date]
        @user_uuid = user_uuid
      end

      def call
        page_size = @page_size.zero? ? 10 : @page_size
        races = resource.where('seq_id > ?', @next_id).limit(page_size).date_asc
        races = date_filter(races) if @date.present?
        next_id = races.last&.seq_id
        ApiResult.success_with_data(races: races, user: User.by_uuid(@user_uuid), next_id: next_id)
      end

      def date_filter(races)
        races.where('end_date >= ?', @date).where('begin_date <= ?', @date)
      end

      def resource
        @host_id.zero? ? Race.main : @host.races
      end

      def host
        @host ||= RaceHost.find(@host_id)
      end
    end
  end
end
