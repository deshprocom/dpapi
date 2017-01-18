module V10
  module Races
    class RacesController < ApplicationController
      include Constants::Error::Common
      RACE_SEARCH_TYPE = %w(recent history)
      # 获取赛事列表
      def index
        # 判断路由是否有u_id
        return render_api_error(MISSING_PARAMETER) if params[:u_id].nil?
        # 检查需要查询的类型是否正确
        unless RACE_SEARCH_TYPE.include?(race_params[:type])
          return render_api_error(UNSUPPORTED_TYPE)
        end
        api_result = Services::Account::RaceListService.call(params[:u_id], race_params[:type])
        template = 'v10/account/races/index'
        V10::Account::RenderResultHelper.render_race_result(self, template, api_result)
      end

      # 获取赛事列表某一赛事详情
      def show; end

      private

      def race_params
        params.permit(:type)
      end
    end
  end
end
