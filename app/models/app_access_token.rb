ACCESS_TOKEN_TTL = 2.weeks

# AppAccessToken存储相关的模块
module AppAccessTokenStorage
  extend ActiveSupport::Concern

  delegate :expire, :exist?, to: :storage

  # AppAccessToken类方法
  module ClassMethods
    def cache_key(access_token)
      "dpapi:access_token:#{access_token}"
    end

    def fetch_from_storage(name, options = nil)
      storage.fetch name, options
    end

    def storage
      Rails.configuration.x.app_access_token.storage
    end
  end

  def storage
    self.class.storage
  end

  def cache_key
    self.class.cache_key access_token
  end

  def save_to_storage(name, value, options = nil)
    storage.write name, value, options
  end
end

##
# DpAPI访问令牌
# 每次成功调用 登录 / 注册 接口, 都会为该调用生成新的访问令牌, 用于后续的接口访问时的身份识别;
# 令牌默认有效期为两小时
# 令牌存储在系统配置的缓存中, 不持久化.
#
# =令牌属性:
#   access_token - 32个字符的令牌字符串
#   client_ip     - 终端用户IP
#   app_key       - 访问接口的合作方应用的 app_key
#   app_secret    - 访问接口的合作方应用的 app_secret
#   user_id       - 登录后的用户uuid
class AppAccessToken
  # 支持批量属性赋值操作
  include ActiveModel::AttributeAssignment
  # 支持修改检查
  include ActiveModel::Dirty
  # 支持json序列化定义的属性
  include ActiveModel::Serializers::JSON
  include AppAccessTokenStorage

  # 定义属性方法
  define_attribute_method :access_token
  define_attribute_method :client_ip
  define_attribute_method :app_key
  define_attribute_method :app_secret
  define_attribute_method :user_id

  attr_accessor :access_token, :client_ip, :app_key, :app_secret, :user_id, :_is_new

  # will_change!是为了触发标记属性被修改了
  def access_token=(value)
    access_token_will_change!
    @access_token = value
  end

  def client_ip=(value)
    client_ip_will_change!
    @client_ip = value
  end

  def app_key=(value)
    app_key_will_change!
    @app_key = value
  end

  def app_secret=(value)
    app_secret_will_change!
    @app_secret = value
  end

  def user_id=(value)
    user_id_will_change!
    @user_id = value
  end

  ##
  # 将变化令牌保持到缓存并延续有效期
  def save
    if changed?
      changes_applied
      if _is_new || exist?(cache_key)
        save_to_storage cache_key, to_json, expires_in: ACCESS_TOKEN_TTL
        _is_new = false
        return true
      end
    end

    false
  end

  ##
  # 令牌是否已过期?
  def expired?
    !exist?(cache_key)
  end

  # 配合to_json使用
  def attributes
    {
      access_token: nil,
      client_ip:    nil,
      app_key:      nil,
      app_secret:   nil,
      user_id:      nil
    }
  end

  # 配合from_json使用
  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  ##
  # 创建新的令牌
  def self.from_credential(credential, user_id)
    create credential.client_ip,
           credential.app_key,
           credential.affiliate_app.try(:app_secret),
           user_id
  end

  def self.create(client_ip, app_key, app_secret, user_id)
    app_access_token = new
    app_access_token._is_new      = true
    app_access_token.access_token = SecureRandom.hex(16).to_s
    app_access_token.client_ip    = client_ip
    app_access_token.app_key      = app_key
    app_access_token.app_secret   = app_secret
    app_access_token.user_id      = user_id
    app_access_token.save
    app_access_token
  end

  ##
  # 强制对令牌延续有效期
  # 如果令牌不存在, 返回 false
  # 成功则返回 true
  def touch
    expire cache_key, ACCESS_TOKEN_TTL
  end

  ##
  # 根据令牌串获取令牌, 如果令牌已过期则返回 nil
  def self.fetch(access_token)
    json = fetch_from_storage cache_key(access_token)
    app_access_token = nil
    unless json.nil?
      app_access_token = new.from_json(json)
      # 因为clear_changes_information 是一个私有方法，所以要使用send才能调用
      app_access_token.send(:clear_changes_information)
      app_access_token
    end
    app_access_token
  end
end
