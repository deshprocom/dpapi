module V10
  module Races
    class RacesController < ApplicationController
      include Constants::Error::Common
      # 获取赛事列表
      def index
        optional! :page_size, values: 0..100, default: 20
        api_result = Services::Account::FilteredRacesService.call(filter_params)
        render_api_result(api_result)
      end

      # 获取赛事列表某一赛事详情
      def show
        @race = Race.find(params[:id])
        @user = User.by_uuid(params[:u_id])
        render 'v10/races/show'
      end

      private

      def filter_params
        params.permit(:page_size,
                      :seq_id,
                      :host_id,
                      :operator,
                      :u_id,
                      :date)
      end

      def render_api_result(result)
        return render_api_error(result.code, result.msg) if result.failure?

        # render 'v10/races/index', locals: { api_result: result,
        #                                     races: result.data[:races],
        #                                     user: result.data[:user],
        #                                     next_id: result.data[:next_id] }
        RenderResultHelper.render_races_result(self, result)
      end
    end
  end
end
