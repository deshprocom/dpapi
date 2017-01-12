# 初始化请求身份信息
module CurrentRequestCredential
  # rubocop:disable Metrics/ParameterLists: 6
  # rubocop:disable Metrics/LineLength: 130
  def self.initialize(client_ip, app_key, access_token = nil, current_user_id = nil, app_access_token = nil, user_agent = nil)
    self.client_ip = client_ip
    self.app_key = app_key
    self.access_token = access_token
    self.current_user_id = current_user_id
    self.app_access_token = app_access_token
    self.user_agent = user_agent
    self.affiliate_app = AffiliateApp.by_app_key(app_key)
  end

  def self.client_ip
    data_store[:client_ip]
  end

  def self.client_ip=(value)
    data_store[:client_ip] = value
  end

  def self.app_key
    data_store[:app_key]
  end

  def self.app_key=(value)
    data_store[:app_key] = value
  end

  def self.access_token
    data_store[:access_token]
  end

  def self.access_token=(value)
    data_store[:access_token] = value
  end

  def self.current_user_id
    data_store[:current_user_id]
  end

  def self.current_user_id=(value)
    data_store[:current_user_id] = value
  end

  def self.app_access_token
    data_store[:app_access_token]
  end

  def self.app_access_token=(value)
    data_store[:app_access_token] = value
  end

  def self.user_agent
    data_store[:user_agent]
  end

  def self.user_agent=(value)
    data_store[:user_agent] = value
  end

  def self.affiliate_app
    data_store[:affiliate_app]
  end

  def self.affiliate_app=(value)
    data_store[:affiliate_app] = value
  end

  def self.data_store
    RequestStore[:current_request_credential] ||= {}
  end

  # def self.clear
  #   RequestStore[:current_request_credential] = {}
  # end
end
