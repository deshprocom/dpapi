module V10
  module News
    class TypesController < ApplicationController
      def index
        types = InfoType.all

        template = 'v10/news/types'
        render template, locals: { api_result: ApiResult.success_result,
                                   types: types }
      end
    end
  end
end

