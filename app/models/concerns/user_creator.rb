module UserCreator
  extend ActiveSupport::Concern

  module ClassMethods
    def create_user_by_mobile(mobile)
      create_params = require_attributes.merge({mobile: mobile})
      user = User.new(create_params)
      user.save
      user
    end

    def create_user_by_email(email, password)
      require_attributes = require_attributes password
      create_attributes = require_attributes.merge({email: email})
      user = User.new(create_attributes)
      user.save
      user
    end

    def require_attributes(password=nil)
      password_salt = SecureRandom.hex(6).slice(0, 6)
      password = password || ::Digest::MD5.hexdigest(SecureRandom.uuid)
      salted_password = ::Digest::MD5.hexdigest(password + password_salt)
      user_name = User.unique_username
      nick_name = user_name
      {   user_uuid: SecureRandom.hex(16),
          user_name: user_name,
          nick_name: nick_name,
          password: salted_password,
          password_salt: password_salt,
          gender: 2,
          reg_date: Time.now,
          last_visit: Time.now
      }
    end
  end
end