module Services
  module Account
    class CertificationAddService
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Account
      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      def call
        # 参数检查
        if user_params.blank? || user_params[:real_name].blank? || user_params[:cert_no].blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 姓名检查
        return ApiResult.error_result(REAL_NAME_FORMAT_WRONG) unless user_params[:real_name] =~ /^[A-z]+$|^[\u4E00-\u9FA5]+$/

        # 身份证格式校验
        unless user_params[:cert_no] =~ /^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{4}$/
          return ApiResult.error_result(CERT_NO_FORMAT_WRONG)
        end

        # 格式都正确
        extra_info = user.user_extra
        if extra_info.blank?
          user.create_user_extra!(user_params.merge(status: 'pending'))
          return ApiResult.success_result
        end

        if extra_info.cert_no.eql?(user_params[:cert_no]) && extra_info.status.eql?('passed')
          return ApiResult.error_result(CERT_NO_ALREADY_EXIST)
        end

        user.user_extra.update!(user_params.merge(status: 'pending'))
        ApiResult.success_result
      end
    end
  end
end
