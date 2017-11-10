module V10
  module Shop
    class RecommendedProductsController < ApplicationController
      def index
        @products = Product.recommended.page(params[:page]).per(params[:page_size])
        render 'v10/shop/products/index'
      end

      def show
        @product = Product.find(params[:id])
      end
    end
  end
end