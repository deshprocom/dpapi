module V10
  module Account
    class CertificationController < ApplicationController
      include UserAccessible
      before_action :login_required, :user_self_required

      def index
        certification_service = Services::Account::CertificationService
        api_result = certification_service.call(@current_user)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?
        template = 'v10/account/users/extra'
        RenderResultHelper.render_certification_result(self, template, api_result)
      end

      def create
        certification_add_service = Services::Account::CertificationAddService
        api_result = certification_add_service.call(@current_user, user_params)
        render_api_result api_result
      end

      private

      def user_params
        params.permit(:real_name,
                      :cert_no,
                      :cert_type,
                      :memo)
      end

      def render_api_result(api_result)
        return render_api_error(api_result.code, api_result.msg) if api_result.failure?
        template = 'v10/account/users/extra'
        RenderResultHelper.render_certification_result(self, template, api_result)
      end
    end
  end
end

