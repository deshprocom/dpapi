module V10
  module Shop
    class ProductsController < ApplicationController
      def index
        @products = Product.page(params[:page]).per(params[:page_size])
        @products = @products.where('title like ?', "%#{params[:keyword]}%") if params[:keyword].present?
      end
    end
  end
end