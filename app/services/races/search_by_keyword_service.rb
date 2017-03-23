module Services
  module Races
    class SearchByKeywordService
      include Serviceable
      include Constants::Error::Common
      attr_accessor :search_params, :user_uuid

      def initialize(user_uuid, search_params)
        self.search_params = search_params
        self.user_uuid = user_uuid
      end

      def call
        keyword = search_params[:keyword]
        next_id = search_params[:next_id].to_i
        page_size = search_params[:page_size].to_i.zero? ? 10 : search_params[:page_size].to_i
        race_list = Race.where('name like ? or location like ?', "%#{keyword}%", "%#{keyword}%")
                        .where("seq_id > ?", next_id)
                        .limit(page_size).order_race_list
        next_id_new = race_list.blank? ? '' : race_list.last.seq_id
        ApiResult.success_with_data(race: race_list, user: User.by_uuid(user_uuid), next_id: next_id_new)
      end
    end
  end
end
