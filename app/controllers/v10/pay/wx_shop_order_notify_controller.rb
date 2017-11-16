module V10
  module Pay
    class WxShopOrderNotifyController < ApplicationController
      def create
        res_xml = Hash.from_xml(request.body.read)
        res = Services::Notify::WxShopNotifyNotifyService.call(res_xml['xml'])
        render xml: res.to_xml(root: 'xml', dasherize: false)
      end
    end
  end
end

