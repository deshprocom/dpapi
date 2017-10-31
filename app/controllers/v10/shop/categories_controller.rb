module V10
  module Shop
    class CategoriesController < ApplicationController
      def index
        @categories = Category.roots
      end

      def children
        @category = Category.find(params[:id])
      end

      def products
        category = Category.find(params[:id])
        @products = Product.in_category(category)
        render 'v10/shop/products/index'
      end
    end
  end
end