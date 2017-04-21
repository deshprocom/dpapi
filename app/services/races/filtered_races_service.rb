module Services
  module Account
    class FilteredRacesService
      include Serviceable
      include Constants::Error::Common

      def initialize(search_params)
        @seq_id     = search_params[:seq_id].to_i
        @host_id    = search_params[:host_id].to_i
        @page_size  = search_params[:page_size]
        @date       = search_params[:date]
        @operator   = search_params[:operator]
        @user_uuid  = search_params[:u_id]
      end

      def call
        if @date.present?
          filtered_by_date
        elsif @seq_id.positive?
          filtered_by_following
        else
          from_now_races
        end
      end

      def from_now_races
        races = resource.where('begin_date >= ?', Time.now.strftime('%Y-%m-%d'))
                        .seq_asc.limit(@page_size)
        races_result(races)
      end

      def filtered_by_date
        races = resource.where('seq_id > ?', @seq_id)
                        .where('end_date >= ?', @date)
                        .where('begin_date <= ?', @date)
                        .seq_asc.limit(@page_size)
        races_result(races)
      end

      def filtered_by_following
        races = if @operator == 'forward'
                  forward_races
                else
                  backward_races
                end
        races_result(races)
      end

      def forward_races
        resource.where('seq_id > ?', @seq_id).seq_asc.limit(@page_size)
      end

      def backward_races
        # 将搜索出的数据，变回正序
        resource.where('seq_id < ?', @seq_id).seq_desc.limit(@page_size).reverse
      end

      def races_result(races)
        ApiResult.success_with_data(races:    races,
                                    user:     User.by_uuid(@user_uuid))
      end

      def resource
        @resource ||= @host_id.zero? ? Race.main : host.races
      end

      def host
        @host ||= RaceHost.find(@host_id)
      end
    end
  end
end
