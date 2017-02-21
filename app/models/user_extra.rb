# +-----------+--------------+------+-----+------------+----------------+
# | Field     | Type         | Null | Key | Default    | Extra          |
# +-----------+--------------+------+-----+------------+----------------+
# | id        | int(11)      | NO   | PRI | NULL       | auto_increment |
# | user_id   | int(11)      | YES  | MUL | NULL       |                |
# | real_name | varchar(50)  | YES  |     | NULL       |                |
# | cert_type | varchar(50)  | YES  |     | chinese_id |                |
# | cert_no   | varchar(255) | YES  |     | NULL       |                |
# | memo      | varchar(255) | YES  |     | NULL       |                |
# +-----------+--------------+------+-----+------------+----------------+

# 用户认证信息表
class UserExtra < ApplicationRecord
  belongs_to :user
end