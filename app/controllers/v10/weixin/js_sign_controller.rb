module V10
  module Weixin
    class JsSignController < ApplicationController
      before_action :set_wx_authorize
      def create
        sign_package = @wx_authorize.get_jssign_package(params[:url])
        render plain: sign_package.inspect
      end

      private

      def set_wx_authorize
        @wx_authorize = WeixinAuthorize::Client.new(ENV['APP_ID'], ENV['APP_SECRET'])
      end
    end
  end
end

