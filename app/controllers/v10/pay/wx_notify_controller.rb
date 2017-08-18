module V10
  module Pay
    class WxNotifyController < ApplicationController
      def create
        result = Hash.from_xml(request.body.read)["xml"]
        Rails.logger.debug("wx notify: #{result}")
        res = Services::Notify::WxNotifyService.call(result)
        render xml: res.to_xml(root: 'xml', dasherize: false)
      end
    end
  end
end

