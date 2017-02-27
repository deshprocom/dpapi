module Services
  module Account
    # rubocop:disable Metrics/LineLength: 130
    class CertificationAddService
      ID_REGEX = /^[1-9]\d{7}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}$|^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|X)$/
      include Serviceable
      include Constants::Error::Common
      include Constants::Error::Account
      attr_accessor :user, :user_params

      def initialize(user, user_params)
        self.user = user
        self.user_params = user_params
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/MethodLength
      def call
        # 参数检查
        if user_params.blank? || user_params[:real_name].blank? || user_params[:cert_no].blank?
          return ApiResult.error_result(MISSING_PARAMETER)
        end

        # 姓名检查
        unless user_params[:real_name] =~ /^[A-z]+$|^[\u4E00-\u9FA5]+$/
          return ApiResult.error_result(REAL_NAME_FORMAT_WRONG)
        end

        # 身份证格式校验
        unless user_params[:cert_no] =~ ID_REGEX
          return ApiResult.error_result(CERT_NO_FORMAT_WRONG)
        end

        # 格式都正确
        extra_info = user.user_extra
        if extra_info.blank?
          user.create_user_extra!(user_params.merge(status: 'pending'))
          data = {
            user_extra: user.user_extra
          }
          return ApiResult.success_with_data(data)
        end

        if extra_info.cert_no.eql?(user_params[:cert_no]) && extra_info.status.eql?('passed')
          return ApiResult.error_result(CERT_NO_ALREADY_EXIST)
        end

        user.user_extra.update!(user_params.merge(status: 'pending'))

        data = {
          user_extra: user.user_extra
        }
        ApiResult.success_with_data(data)
      end
    end
  end
end
