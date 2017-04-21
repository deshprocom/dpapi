module V10
  module Races
    class SearchByKeywordController < ApplicationController
      include Constants::Error::Common
      def index
        keyword = search_params[:keyword]
        return render_api_error(MISSING_PARAMETER) if keyword.blank?
        api_result = Services::Races::SearchByKeywordService.call(params[:u_id], search_params)
        render_api_result(api_result)
      end

      private

      def search_params
        params.permit(:keyword, :next_id, :page_size)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end

