=begin
+-----------------+--------------+------+-----+---------+----------------+
| Field           | Type         | Null | Key | Default | Extra          |
+-----------------+--------------+------+-----+---------+----------------+
| id              | int(11)      | NO   | PRI | NULL    | auto_increment |
| name            | varchar(256) | YES  |     | NULL    |                |
| seq_id          | bigint(20)   | NO   | UNI | 0       |                |
| logo            | varchar(256) | YES  |     | NULL    |                |
| prize           | varchar(255) | NO   |     |         |                |
| location        | varchar(256) | YES  |     | NULL    |                |
| begin_date      | date         | YES  | MUL | NULL    |                |
| end_date        | date         | YES  |     | NULL    |                |
| status          | int(11)      | NO   |     | 0       |                |
| created_at      | datetime     | NO   |     | NULL    |                |
| updated_at      | datetime     | NO   |     | NULL    |                |
| ticket_status   | varchar(30)  | YES  |     | unsold  |                |
| ticket_price    | int(11)      | YES  |     | 0       |                |
| published       | tinyint(1)   | YES  |     | 0       |                |
| ticket_sellable | tinyint(1)   | YES  |     | 1       |                |
| describable     | tinyint(1)   | YES  |     | 1       |                |
+-----------------+--------------+------+-----+---------+----------------+
=end
class Race < ApplicationRecord
  include TicketNumberCounter

  mount_uploader :logo, PhotoUploader

  # 增加二级查询缓存，缓存过期时间六小时
  second_level_cache(version: 1, expires_in: 6.hours)

  has_one :race_desc, dependent: :destroy
  has_one :ticket_info, dependent: :destroy
  has_many :race_follows
  has_many :tickets
  has_many :race_orders, class_name: PurchaseOrder
  accepts_nested_attributes_for :ticket_info, update_only: true
  accepts_nested_attributes_for :race_desc, update_only: true

  validates :name, :prize, :logo, presence: true
  enum status: [:unbegin, :go_ahead, :ended, :closed]
  enum ticket_status: { unsold: 'unsold', selling: 'selling', end: 'end', sold_out: 'sold_out' }
  ransacker :status, formatter: proc { |v| statuses[v] } if ENV['CURRENT_PROJECT'] == 'dpcms'

  after_initialize do
    self.begin_date ||= Date.current
    self.end_date ||= Date.current
  end

  before_save do
    self.seq_id = Services::RaceSequencer.call(self) if begin_date_changed?
  end

  # 默认取已发布的赛事
  default_scope { where(published: true) } unless ENV['CURRENT_PROJECT'] == 'dpcms'
  # 近期赛事
  scope :recent_races, -> { where('end_date >= ?', Time.zone.now.end_of_day).where.not(status: [2, 3]) }
  # 排序
  scope :order_race_list, -> { order(begin_date: :asc).order(end_date: :asc).order(created_at: :asc) }
  scope :seq_desc, -> { order(seq_id: :desc) }
  scope :ticket_sellable, -> { where(ticket_sellable: true) }

  # 获取指定条数的近期赛事 (5条)
  def self.limit_recent_races(numbers = 5)
    recent_races.limit(numbers).order_race_list
  end

  def to_snapshot
    {
      race_id:      id,
      name:         name,
      logo:         preview_logo,
      prize:        prize,
      location:     location,
      ticket_price: ticket_price,
      begin_date:   begin_date,
      end_date:     end_date
    }
  end

  def publish!
    update(published: true)
  end

  def unpublish!
    update(published: false)
  end

  def cancel_sell!
    update(ticket_sellable: false)
  end

  def preview_logo
    ENV['CMS_PHOTO_PATH'] + logo.url(:preview)
  end

  def big_logo
    ENV['CMS_PHOTO_PATH'] + logo.url
  end
end
