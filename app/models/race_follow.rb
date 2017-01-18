# +------------+----------+------+-----+---------+----------------+
# | Field      | Type     | Null | Key | Default | Extra          |
# +------------+----------+------+-----+---------+----------------+
# | id         | int(11)  | NO   | PRI | NULL    | auto_increment |
# | user_id   | int(11)  | YES  | MUL | NULL    |                |
# | race_id   | int(11)  | YES  | MUL | NULL    |                |
# | created_at | datetime | NO   |     | NULL    |                |
# | updated_at | datetime | NO   |     | NULL    |                |
# +------------+----------+------+-----+---------+----------------+
class RaceFollow < ApplicationRecord
  belongs_to :user
  belongs_to :race

  # 判断某个赛事某人是否关注
  def self.is_follow?(user_id, race_id)
    where(user_id: user_id, race_id: race_id).present?
  end
end
