module DpAPI
  class ApiRequestCredential
    def initialize(app)
      @app = app
    end

    def call(env)
      #解析请求头信息 并初始化到线程中
      parse_request_header(env)
      #校验用户传递过来的信息
      validate_request(env)
    end

    private
    def parse_request_header(env)
      client_ip     = env['HTTP_X_DP_CLIENT_IP']
      app_key       = env['HTTP_X_DP_APP_KEY']
      access_token  = env['HTTP_X_DP_ACCESS_TOKEN']
      user_agent    = env['HTTP_USER_AGENT']
      Rails.logger.info "[ApiRequestCredential] client_ip: #{client_ip}, app_key: #{app_key}, access_token: #{access_token}, user_agent: #{user_agent}"

      #如果用户有传access_token 那么拿着access_token去缓存获取对应的信息
      #app_access_token = nil
      #current_user_id  = nil
      #if access_token.present?
        #app_access_token = AppAccessToken.fetch(access_token)
        #current_user_id  = app_access_token.user_id if app_access_token.present?
      #end

      #初始化信息到线程中
      CurrentRequestCredential.initialize(client_ip, app_key, access_token, current_user_id = nil, user_agent)
    end

    def validate_request(env)
      #检查请求头是否包含 client_ip 和 app_key
      if CurrentRequestCredential.client_ip.blank? or CurrentRequestCredential.app_key.blank?
        return http_no_credential
      end

      #检查app_key是否正确
      unless CurrentRequestCredential.app_key_valid?
        return http_invalid_credential
      end

      #传递了access_token 但是找不到相应的数据
      # if CurrentRequestCredential.access_token.present? and CurrentRequestCredential.app_access_token.nil?
      #   http_credential_not_match
      # end

      #请求都正常
      @app.call(env)
    end

    def http_no_credential
      status = Constants::HttpErrorCode::HTTP_NO_CREDENTIAL
      headers = {
          "Content-Type"    => "application/json",
          "x-dp-code"  => status,
          "x_dp_msg"   => "请求缺少身份信息."}
      [status, headers, []]
    end

    def http_invalid_credential
      status = Constants::HttpErrorCode::HTTP_INVALID_CREDENTIAL
      headers = {
          "Content-Type"    => "application/json",
          "x-dp-code"  => status,
          "x_dp_msg"   => "无效的请求身份."}
      [status, headers, []]
    end

    def http_credential_not_match
      status = Constants::HttpErrorCode::HTTP_CREDENTIAL_NOT_MATCH
      headers = {
          "Content-Type"    => "application/json",
          "x-dp-code"  => status,
          "x_dp_msg"   => "无效的请求身份."}
      [status, headers, []]
    end
  end
end