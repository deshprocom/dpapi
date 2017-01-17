module V10
  module Races
    class RacesController < ApplicationController
      include Constants::Error::Common
      # 获取赛事列表
      def index
        user_uuid = params[:u_id]
        return render_api_error(MISSING_PARAMETER) if user_uuid.nil?
        api_result = Services::Account::RaceListService.call(user_uuid)
        template = 'v10/account/races/base'
        V10::Account::RenderResultHelper.render_race_result(self, template, api_result)
      end

      # 获取赛事列表某一赛事详情
      def show; end
    end
  end
end
