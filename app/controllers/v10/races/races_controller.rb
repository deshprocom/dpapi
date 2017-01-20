module V10
  module Races
    class RacesController < ApplicationController
      include Constants::Error::Common
      OPERATOR_TYPE = %w(up down).freeze
      # 获取赛事列表
      def index
        search_params = search_permit_params.dup
        unless search_params[:page_size] =~ /^[0-9]+$/ && OPERATOR_TYPE.include?(search_params[:operator])
          return render_api_error(PARAM_FORMAT_ERROR)
        end
        api_result = Services::Account::RaceListService.call(params[:u_id], search_params)
        render_api_result api_result
      end

      # 获取赛事列表某一赛事详情
      def show
        user_uuid = params[:u_id]
        race_id = params[:id]
        api_result = Services::Account::RaceDetailService.call(user_uuid, race_id)
        template = 'v10/account/races/show'
      end

      private

      def search_permit_params
        params.permit(:page_size,
                      :seq_id,
                      :operator,
                      :begin_date)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        template = 'v10/account/races/index'
        V10::Account::RenderResultHelper.render_race_result(self, template, result)
      end
    end
  end
end
