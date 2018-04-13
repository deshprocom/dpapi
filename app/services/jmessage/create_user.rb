module Services
  module Jmessage
    class CreateUser
      include Serviceable
      include Constants::Error::Common

      def initialize(user)
        @user = user
        @local_user = @user.j_user
      end

      def call
        # 尝试从极光获取用户信息
        @remote_user = ::Jmessage::User.user_info(@user.user_name)
        return ApiResult.success_with_data(j_user: @local_user) if user_exists?

        return ApiResult.error_result(SYSTEM_ERROR) if user_unnormal

        params = payload

        # 上传用户头像
        if @user.avatar_path.present?
          close_buffer_limit
          img_result = ::Jmessage::User.upload_image(open(@user.avatar_path))
          if img_result['media_id'].present?
            params.merge!(avatar: img_result['media_id'])
          end
          open_buffer_limit
        end

        # 去极光注册用户信息
        result = ::Jmessage::User.register(params)
        Rails.logger.info "Jmessage service result: -> #{result}"
        # 说明注册失败
        if result.first['error'].present?
          return ApiResult.error_result(result.first['error']['code'], result.first['error']['message']) if user.nil?
        end
        # 在数据库创建该用户信息
        j_user = JUser.create(user_id: @user.id, username: params[:username], password: params[:password] )
        ApiResult.success_with_data(j_user: j_user)
      end

      def user_exists?
        local_user_exists? && remote_user_exists?
      end

      def local_user_exists?
        @local_user.present?
      end

      def remote_user_exists?
        @remote_user['error'].blank? ? true : false
      end

      def user_unnormal
        # 本地用户存在 远程不存在 或者 远程存在 本地不存在
        local_user_exists? != remote_user_exists?
      end

      def payload
        { username: @user.user_name,
          nickname: @user.nick_name,
          password: ::Digest::MD5.hexdigest(SecureRandom.uuid)
        }
      end

      # def avatar_url_to_tempfile(avatar_path)
      #   stream = open(avatar_path)
      #   Services::StreamIo.write_stream_to_file(stream) unless stream.is_a? Tempfile
      # end
      #
      def close_buffer_limit
        OpenURI::Buffer.send :remove_const, 'StringMax' if string_max_defined?
        OpenURI::Buffer.const_set 'StringMax', 0
      end

      def open_buffer_limit
        OpenURI::Buffer.send :remove_const, 'StringMax' if string_max_defined?
        OpenURI::Buffer.const_set 'StringMax', 10240
      end

      def string_max_defined?
        OpenURI::Buffer.const_defined?('StringMax')
      end
    end
  end
end

