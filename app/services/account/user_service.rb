module Services
  module Account
    class UserService
      include Constants::HttpErrorCode
      include Constants::SignUpErrorCode
      include Constants::CommonErrorCode

      def self.create_user_by_mobile(user_params)
        mobile = user_params[:mobile]

        #检查手机格式是否存在
        unless UserValidator.mobile_valid?(mobile)
          return ApiResult.error_result(MOBILE_FORMAT_WRONG)
        end

        #检查手机号是否存在
        if UserValidator.mobile_exists?(mobile)
          return ApiResult.error_result(MOBILE_ALREADY_USED)
        end

        #可以注册
        user_name = User.unique_username
        reg_date = Time.now
        last_visit = reg_date

        create_attrs = {
            user_name: user_name,
            mobile: mobile,
            reg_date: reg_date,
            last_visit: last_visit
        }
        create_user(create_attrs)
      end

      def self.create_user_by_email(user_params)
      end

      protected
      def self.create_user(user_attributes)
        password_salt = SecureRandom.hex(6).slice(0, 6)
        password = user_attributes[:password] || ::Digest::MD5.hexdigest(SecureRandom.uuid)
        password_new = ::Digest::MD5.hexdigest(password + password_salt)
        gender = user_attributes[:gender] || 2
        reg_date = user_attributes[:reg_date] || Time.now
        last_visit = user_attributes[:last_visit] || reg_date

        attrs = user_attributes.merge({
                                          user_uuid: SecureRandom.hex(16),
                                          password: password_new,
                                          password_salt: password_salt,
                                          gender: gender,
                                          reg_date: reg_date,
                                          last_visit: last_visit
                                      })
        new_user = User.new(attrs)
        begin
          new_user.save!
        rescue ActiveRecord::ActiveRecordError => e
          Rails.logger.error "Failed to save new user: #{e.inspect}"
          return ApiResult.error_result(DATABASE_ERROR)
        end

        data = {
            user: new_user
        }

        ApiResult.success_with_data(data)
      end
    end
  end
end