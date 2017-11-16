module V10
  module Shop
    class ProductsController < ApplicationController
      def index
        @products = Product.published.page(params[:page]).per(params[:page_size])
        @products = @products.where('title like ?', "%#{params[:keyword]}%") if params[:keyword].present?
      end

      def show
        @product = Product.published.find(params[:id])
      end
    end
  end
end