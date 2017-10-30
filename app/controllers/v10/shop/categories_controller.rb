module V10
  module Shop
    class CategoriesController < ApplicationController
      def index
        @categories = Category.roots
      end

      def children
        @category = Category.find(params[:id])
      end
    end
  end
end