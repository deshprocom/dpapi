module V10
  module News
    class SearchController < ApplicationController
      def index
        page_size = permit_params[:page_size].blank? ? '10' : permit_params[:page_size]
        next_id = permit_params[:next_id].blank? ? '0' : permit_params[:next_id]
        keyword = permit_params[:keyword].blank? ? '' : permit_params[:keyword]

        news_all = Info.where('title like ? or source like ?', "%#{keyword}%", "%#{keyword}%")
                       .where('id > ?', next_id).limit(page_size)

        # 去掉类别为未发布的资讯
        news = news_all.reject{ |item| item.info_type.blank? }

        next_id = news.last.try(:id) || 0
        template = 'v10/news/search'
        render template, locals: { api_result: ApiResult.success_result,
                                   news: news,
                                   next_id: next_id }
      end

      private

      def permit_params
        params.permit(:page_size,
                      :next_id,
                      :keyword)
      end
    end
  end
end

