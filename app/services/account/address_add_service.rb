module Services
  module Account
    class AddressAddService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Sign

      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        # 检查参数是否为空
        if user_params[:consignee].blank? || user_params[:mobile].blank? || user_params[:address].blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 判断手机格式是否正确
        return ApiResult.error_result(MOBILE_FORMAT_WRONG) unless UserValidator.mobile_valid?(user_params[:mobile])

        user_params[:id].blank? ? create_address : update_address
      end

      private

      def create_address
        user.shipping_addresses.create! user_params
        ApiResult.success_result
      end

      def update_address
        address = ShippingAddress.find(user_params.delete(:id))
        address.update! user_params
        ApiResult.success_result
      end
    end
  end
end
