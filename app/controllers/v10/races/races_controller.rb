module V10
  module Races
    class RacesController < ApplicationController
      include Constants::Error::Common
      OPERATOR_TYPE = %w(forward backward).freeze
      # 获取赛事列表
      def index
        search_params = search_permit_params.dup
        unless search_params[:page_size] =~ /^[0-9]+$/ && OPERATOR_TYPE.include?(search_params[:operator])
          return render_api_error(PARAM_FORMAT_ERROR)
        end
        api_result = Services::Account::RaceListService.call(params[:u_id], search_params)
        template = 'v10/races/index'
        render_api_result(api_result, template)
      end

      # 获取赛事列表某一赛事详情
      def show
        api_result = Services::Account::RaceDetailService.call(params[:u_id], params[:id])
        template = 'v10/races/show'
        render_api_result(api_result, template)
      end

      private

      def search_permit_params
        params.permit(:page_size,
                      :seq_id,
                      :operator,
                      :begin_date)
      end

      def render_api_result(result, template)
        return render_api_error(result.code, result.msg) if result.failure?

        RenderResultHelper.render_race_result(self, template, result)
      end
    end
  end
end
