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

  # 增加二级查询缓存，缓存过期时间一周
  acts_as_cached(version: 1, expires_in: 1.week)

  # 刷新访问时间
  def touch_visit!
    self.last_visit = Time.zone.now
    save
  end
end
