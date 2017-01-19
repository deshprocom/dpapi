# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
# | name       | varchar(256) | YES  |     | NULL    |                |
# | seq_id     | varchar(255) | NO   |     | 0       |                |
# | logo       | varchar(256) | YES  |     | NULL    |                |
# | prize      | int(11)      | NO   |     | 0       |                |
# | location   | varchar(256) | YES  |     | NULL    |                |
# | begin_date | date         | YES  |     | NULL    |                |
# | end_date   | date         | YES  |     | NULL    |                |
# | status     | int(11)      | NO   |     | 0       |                |
# | created_at | datetime     | NO   |     | NULL    |                |
# | updated_at | datetime     | NO   |     | NULL    |                |
# +------------+--------------+------+-----+---------+----------------+
class Race < ApplicationRecord
  has_many :race_descs
  has_many :race_follows
  has_many :race_orders

  # 近期赛事
  scope :recent_races, -> { where('end_date >= ?', Time.zone.now.end_of_day).where.not(status: [2, 3]) }

  # 排序
  scope :order_race_list, -> { order(begin_date: :asc).order(end_date: :asc).order(created_at: :asc) }

  # 获取指定条数的近期赛事 (5条)
  def self.limit_recent_races(numbers = 5)
    recent_races.limit(numbers).order_race_list
  end

  def followed?(user_id)
    race_follows.exists?(user_id: user_id)
  end

  def ordered?(user_id)
    race_orders.exists?(user_id: user_id)
  end
end
