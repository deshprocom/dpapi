module V10
  module Races
    # 获取主页赛事列表
    class RecentRacesController < ApplicationController
      def index
        api_result = Services::Account::RaceRecentService.call(params[:u_id], race_params[:numbers])
        render_api_result api_result
      end

      private

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/races/index'
        V10::Account::RenderResultHelper.render_race_result(self, template, result)
      end
      def race_params
        params.permit(:numbers)
      end
    end
  end
end
