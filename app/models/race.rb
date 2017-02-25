# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
# | name       | varchar(256) | YES  |     | NULL    |                |
# | seq_id     | bigint(20)   | NO   |     | 0       |                |
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
  include TicketNumberCounter

  has_one :race_desc
  has_one :ticket_info
  has_many :race_follows
  has_many :race_orders, class_name: PurchaseOrder

  # 近期赛事
  scope :recent_races, -> { where('end_date >= ?', Time.zone.now.end_of_day).where.not(status: [2, 3]) }

  # 排序
  scope :order_race_list, -> { order(begin_date: :asc).order(end_date: :asc).order(created_at: :asc) }

  # 获取指定条数的近期赛事 (5条)
  def self.limit_recent_races(numbers = 5)
    recent_races.limit(numbers).order_race_list
  end

  def to_snapshot
    {
      race_id:      id,
      name:         name,
      logo:         logo,
      prize:        prize,
      location:     location,
      ticket_price: ticket_price,
      begin_date:   begin_date,
      end_date:     end_date
    }
  end
end
