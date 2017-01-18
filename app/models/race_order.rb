# +------------+----------+------+-----+---------+----------------+
# | Field      | Type     | Null | Key | Default | Extra          |
# +------------+----------+------+-----+---------+----------------+
# | id         | int(11)  | NO   | PRI | NULL    | auto_increment |
# | race_id   | int(11)  | YES  | MUL | NULL    |                |
# | user_id   | int(11)  | YES  | MUL | NULL    |                |
# | created_at | datetime | NO   |     | NULL    |                |
# | updated_at | datetime | NO   |     | NULL    |                |
# +------------+----------+------+-----+---------+----------------+
class RaceOrder < ApplicationRecord
  belongs_to :race
  belongs_to :user

  # 判断某个赛事某人是否购票
  def self.is_order?(user_id, race_id)
    where(user_id: user_id, race_id: race_id).present?
  end
end
