module CurrentRequestCredential
  #初始化请求身份信息
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
    self.data_store[:client_ip]
  end

  def self.client_ip=(value)
    self.data_store[:client_ip] = value
  end

  def self.app_key
    self.data_store[:app_key]
  end

  def self.app_key=(value)
    self.data_store[:app_key] = value
  end

  def self.access_token
    self.data_store[:access_token]
  end

  def self.access_token=(value)
    self.data_store[:access_token] = value
  end

  def self.current_user_id
    self.data_store[:current_user_id]
  end

  def self.current_user_id=(value)
    self.data_store[:current_user_id] = value
  end

  def self.app_access_token
    self.data_store[:app_access_token]
  end

  def self.app_access_token=(value)
    self.data_store[:app_access_token] = value
  end

  def self.user_agent
    self.data_store[:user_agent]
  end

  def self.user_agent=(value)
    self.data_store[:user_agent] = value
  end

  def self.affiliate_app
    self.data_store[:affiliate_app]
  end

  def self.affiliate_app=(value)
    self.data_store[:affiliate_app] = value
  end

  def self.data_store
    RequestStore[:current_request_credential] ||= {}
  end

  def self.clear
    RequestStore[:current_request_credential] = {}
  end
end