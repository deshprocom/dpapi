module V10
  module News
    class TypesController < ApplicationController
      def index
        types = InfoType.all.order(level: :asc)

        template = 'v10/news/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   types: types }
      end

      def show
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].blank? ? '0' : permit_params[:next_id]
        type = InfoType.find(params[:id])
        news = type.infos.where('id > ?', next_id).limit(page_size)
        top_new = type.infos.topped.first
        next_id = news.last.try(:id) || 0

        template = 'v10/news/show'
        render template, locals: { api_result: ApiResult.success_result,
                                   news: news,
                                   next_id: next_id,
                                   top_new: top_new }
      end

      private

      def permit_params
        params.permit(:page_size,
                      :next_id)
      end
    end
  end
end

