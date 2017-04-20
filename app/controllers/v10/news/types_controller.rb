module V10
  module News
    class TypesController < ApplicationController
      def index
        types = InfoType.all

        template = 'v10/news/index'
        render template, locals: { api_result: ApiResult.success_result,
                                   types: types }
      end

      def show
        news = InfoType.find(params[:id]).infos

        template = 'v10/news/show'
        render template, locals: { api_result: ApiResult.success_result,
                                   news: news }
      end
    end
  end
end

