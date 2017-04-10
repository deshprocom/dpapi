module Services
  module Account
    class RaceListService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :user_uuid, :search_params

      def initialize(user_uuid, search_params)
        self.user_uuid = user_uuid
        self.search_params = search_params
        @seq_id = search_params[:seq_id]
      end

      def call
        @seq_id.present? ? search_by_seq_id : search_by_date
      end

      private

      def main_race
        Race.main
      end

      def search_by_seq_id
        operator = operator_parse search_params[:operator]
        page_size = search_params[:page_size]
        lists = if operator.eql?('>')
                  main_race.where("seq_id #{operator} ?", @seq_id.to_i).limit(page_size).order(seq_id: :asc)
                else
                  main_race.where("seq_id #{operator} ?", @seq_id.to_i).limit(page_size).order(seq_id: :desc)
                end
        next_id = lists.blank? ? '' : lists.last.seq_id
        ApiResult.success_with_data(race: lists, user: User.by_uuid(user_uuid), next_id: next_id)
      end

      def search_by_date
        operator = operator_parse search_params[:operator]
        page_size = search_params[:page_size]
        begin_date = search_params[:begin_date]
        return ApiResult.error_result(MISSING_PARAMETER) if begin_date.blank?

        lists = if operator.eql?('>')
                  main_race.where("begin_date #{operator} ?", begin_date).limit(page_size).order_race_list
                else
                  main_race.where("begin_date #{operator} ?", begin_date)
                           .limit(page_size)
                           .order(begin_date: :desc).order(end_date: :desc).order(created_at: :desc)
                end
        next_id = lists.blank? ? '' : lists.last.begin_date
        ApiResult.success_with_data(race: lists, user: User.by_uuid(user_uuid), next_id: next_id)
      end

      def operator_parse(operator)
        operator.eql?('backward') ? '<' : '>'
      end
    end
  end
end
