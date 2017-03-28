=begin
+-----------------+--------------+------+-----+----------+----------------+
| Field           | Type         | Null | Key | Default  | Extra          |
+-----------------+--------------+------+-----+----------+----------------+
| id              | int(11)      | NO   | PRI | NULL     | auto_increment |
| user_id         | int(11)      | YES  | MUL | NULL     |                |
| race_id         | int(11)      | YES  | MUL | NULL     |                |
| ticket_infos_id | int(11)      | YES  | MUL | NULL     |                |
| ticket_type     | varchar(30)  | YES  |     | e_ticket |                |
| memo            | varchar(255) | YES  |     | NULL     |                |
| canceled        | tinyint(1)   | YES  |     | 0        |                |
| created_at      | datetime     | NO   |     | NULL     |                |
| updated_at      | datetime     | NO   |     | NULL     |                |
+-----------------+--------------+------+-----+----------+----------------+
=end

class Ticket < ApplicationRecord
  belongs_to :race
  belongs_to :user

  scope :valid, -> { where(canceled: false) }

  def self.valid_race_ticket(race_id)
    where(race_id: race_id).valid
  end
end
