module Services
  module Players
    class FilteringService
      include Serviceable
      include Constants::Error::Common

      def initialize(filter_params)
        @page_index = filter_params[:page_index].to_i
        @page_size = filter_params[:page_size].to_i
        @region = filter_params[:region]
      end

      def call
        players = Player.earn_order.offset(@page_index * @page_size).limit(@page_size)
        filtering_region players
      end

      def filtering_region(relation)
        return relation if @region == 'global'

        relation.where(country: %w(中国 澳门 香港))
      end
    end
  end
end
