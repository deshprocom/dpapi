# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
# | name       | varchar(256) | YES  |     | NULL    |                |
# | logo       | varchar(256) | YES  |     | NULL    |                |
# | prize      | int(11)      | NO   |     | 0       |                |
# | address    | varchar(256) | YES  |     | NULL    |                |
# | start_time | datetime     | YES  |     | NULL    |                |
# | end_time   | datetime     | YES  |     | NULL    |                |
# | status     | int(11)      | NO   |     | 0       |                |
# | created_at | datetime     | NO   |     | NULL    |                |
# | updated_at | datetime     | NO   |     | NULL    |                |
# +------------+--------------+------+-----+---------+----------------+
class Race < ApplicationRecord
  has_many :race_descs
  has_many :race_follows
  has_many :race_orders

  # 更多近期赛事
  scope :recent_races,  -> { where('end_time > ?', Time.zone.now.end_of_day).where.not(status: [2, 3]) }

  # 历史所有赛事
  scope :history_races, -> { where('end_time < ?', Time.zone.now.end_of_day) }

  # 获取指定条数的近期赛事 (5条)
  def self.limit_recent_races
    recent_races.limit(5)
  end

  def followed?(user_id)
    race_follows.exists?(user_id: user_id)
  end

  def ordered?(user_id)
    race_orders.exists?(user_id: user_id)
  end
end
