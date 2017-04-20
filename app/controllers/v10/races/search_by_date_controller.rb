module V10
  module Races
    class SearchByDateController < ApplicationController
      include Constants::Error::Common
      def index
        date = search_params[:date]
        return render_api_error(MISSING_PARAMETER) if date.blank?
        api_result = Services::Races::SearchByDateService.call(params[:u_id], search_params)
        render_api_result(api_result)
      end

      private

      def search_params
        params.permit(:date, :next_id, :page_size)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end

