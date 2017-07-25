module Services
  module Players
    class FilteringService
      include Serviceable
      include Constants::Error::Common

      def initialize(filter_params)
        @page_index = filter_params[:page_index].to_i
        @page_size = filter_params[:page_size].to_i
        @offset = @page_index * @page_size
        @region = filter_params[:region]
        @year = filter_params[:year]
      end

      def call
        if @year.blank?
          players = Player.earn_order.offset(@offset).limit(@page_size)
        else
          # RaceRank.unscoped.joins(join_where).joins(:player).group(:player_id)
          # .order('sum_earning desc').select(:player_id, 'SUM(earning) AS sum_earning')
          # .where('country like ?', '%中国')
          join_where = "INNER JOIN races ON races.begin_date >= '#{year_first_day}'
AND races.begin_date <= '#{year_last_day}' AND races.id = race_ranks.race_id"
          players = Player.joins(join_where).joins(:race_ranks).group(:player_id)
                          .select('players.*', 'SUM(earning) AS dpi_total_earning')
                          .earn_order
                          .offset(@offset).limit(@page_size)
        end
        filtering_region players
      end

      def year_first_day
        "#{@year}-01-01"
      end

      def year_last_day
        "#{@year}-12-31"
      end

      def filtering_region(relation)
        return relation if @region == 'global'

        relation.where('country like ?', '%中国')
        # relation.where(country: %w(中国 澳门 香港))
      end
    end
  end
end
