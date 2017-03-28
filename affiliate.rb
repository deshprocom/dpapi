# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
# | aff_uuid   | varchar(36)  | YES  | UNI | NULL    |                |
# | aff_name   | varchar(100) | YES  | UNI | NULL    |                |
# | aff_type   | varchar(50)  | YES  |     | company |                |
# | status     | int(11)      | YES  |     | 0       |                |
# | mobile     | varchar(20)  | YES  | UNI | NULL    |                |
# | created_at | datetime     | NO   |     | NULL    |                |
# | updated_at | datetime     | NO   |     | NULL    |                |
# +------------+--------------+------+-----+---------+----------------+

# 授权的平台用户表
# 一个授权的平台用户可以有多个应用
class Affiliate < ApplicationRecord
  has_many :affiliate_apps, dependent: :destroy
end
