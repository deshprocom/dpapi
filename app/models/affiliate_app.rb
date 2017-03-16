# +--------------+--------------+------+-----+---------+----------------+
# | Field        | Type         | Null | Key | Default | Extra          |
# +--------------+--------------+------+-----+---------+----------------+
# | id           | int(11)      | NO   | PRI | NULL    | auto_increment |
# | affiliate_id | int(11)      | YES  | MUL | NULL    |                |
# | app_id       | varchar(50)  | YES  |     | NULL    |                |
# | app_name     | varchar(100) | YES  |     | NULL    |                |
# | app_key      | varchar(36)  | YES  | UNI | NULL    |                |
# | app_secret   | varchar(36)  | YES  |     | NULL    |                |
# | status       | int(11)      | YES  |     | 0       |                |
# | created_at   | datetime     | NO   |     | NULL    |                |
# | updated_at   | datetime     | NO   |     | NULL    |                |
# +--------------+--------------+------+-----+---------+----------------+

# 已授权的app应用列表
# 一个授权的app应用对应某一个平台用户
class AffiliateApp < ApplicationRecord
  belongs_to :affiliate

  second_level_cache version: 1, expires_in: 1.week

  def self.by_app_key(app_key)
    fetch_by_uniq_keys(app_key: app_key)
  end
end
