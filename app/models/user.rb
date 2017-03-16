# +---------------+--------------+------+-----+---------+----------------+
# | Field         | Type         | Null | Key | Default | Extra          |
# +---------------+--------------+------+-----+---------+----------------+
# | id            | int(11)      | NO   | PRI | NULL    | auto_increment |
# | user_uuid     | varchar(32)  | NO   | UNI | NULL    |                |
# | user_name     | varchar(32)  | YES  | UNI | NULL    |                |
# | nick_name     | varchar(32)  | YES  |     | NULL    |                |
# | password      | varchar(32)  | YES  |     | NULL    |                |
# | password_salt | varchar(255) | NO   |     |         |                |
# | gender        | int(11)      | YES  |     | 0       |                |
# | email         | varchar(64)  | YES  | UNI | NULL    |                |
# | mobile        | varchar(16)  | YES  | UNI | NULL    |                |
# | avatar        | varchar(255) | YES  |     | NULL    |                |
# | birthday      | date         | YES  |     | NULL    |                |
# | reg_date      | datetime     | YES  |     | NULL    |                |
# | last_visit    | datetime     | YES  |     | NULL    |                |
# | created_at    | datetime     | NO   |     | NULL    |                |
# | updated_at    | datetime     | NO   |     | NULL    |                |
# +---------------+--------------+------+-----+---------+----------------+

# 用户信息表
class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator
  mount_uploader :avatar, AvatarUploader

  attr_accessor :avatar_path

  # 增加二级查询缓存，缓存过期时间六小时
  second_level_cache(version: 1, expires_in: 6.hours)

  # 关联关系
  has_many :race_follows
  has_one  :user_extra
  has_many :shipping_addresses, -> { order(default: :desc) }
  has_many :tickets
  has_many :orders, class_name: PurchaseOrder

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end

  # 上传图片给图片赋值的时候 创建图片路径
  def avatar=(value)
    super

    if avatar.file.present? &&
       avatar.file.respond_to?(:path) &&
       File.exist?(avatar.file.path)
      self.avatar_md5 = Digest::MD5.file(avatar.file.path).hexdigest
    end
  end

  def avatar_path
    DpapiConfig.domain_path.to_s + avatar.to_s unless avatar.blank?
  end
end
