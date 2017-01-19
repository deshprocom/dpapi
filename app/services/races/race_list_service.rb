module Services
  module Account
    class RaceListService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :user_uuid, :search_params

      def initialize(user_uuid, search_params)
        self.user_uuid = user_uuid
        self.search_params = search_params
      end

      def call
        search_params[:seq_id].present? ? search_by_seq_id : search_by_date
      end

      private

      def search_by_seq_id
        return ApiResult.error_result(MISSING_PARAMETER) if search_params[:seq_id].blank?
        operator = operator_parse search_params[:operator]
        page_size = search_params[:page_size]
        lists = Race.where("seq_id #{operator} ?", search_params[:seq_id]).limit(page_size).order_race_list
        ApiResult.success_with_data(race: lists, user: User.by_uuid(user_uuid))
      end

      def search_by_date
        return ApiResult.error_result(MISSING_PARAMETER) if search_params[:begin_date].blank?
        operator = operator_parse search_params[:operator]
        page_size = search_params[:page_size]
        lists = Race.where("begin_date #{operator} ?", search_params[:begin_date]).limit(page_size).order_race_list
        ApiResult.success_with_data(race: lists, user: User.by_uuid(user_uuid))
      end

      def operator_parse(operator)
        operator.eql?('up') ? '<=' : '>='
      end
    end
  end
end
