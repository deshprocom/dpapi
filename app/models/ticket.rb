=begin
+-----------------+--------------+------+-----+------------+----------------+
| Field           | Type         | Null | Key | Default    | Extra          |
+-----------------+--------------+------+-----+------------+----------------+
| id              | int(11)      | NO   | PRI | NULL       | auto_increment |
| user_id         | int(11)      | YES  | MUL | NULL       |                |
| race_id         | int(11)      | YES  | MUL | NULL       |                |
| ticket_infos_id | int(11)      | YES  | MUL | NULL       |                |
| cert_type       | varchar(50)  | YES  |     | chinese_id |                |
| cert_no         | varchar(255) | YES  |     | NULL       |                |
| ticket_type     | varchar(30)  | YES  |     | e_ticket   |                |
| status          | varchar(30)  | YES  |     | unpaid     |                |
| memo            | varchar(255) | YES  |     | NULL       |                |
| created_at      | datetime     | NO   |     | NULL       |                |
| updated_at      | datetime     | NO   |     | NULL       |                |
+-----------------+--------------+------+-----+------------+----------------+
=end

class Ticket < ApplicationRecord
  belongs_to :race
  belongs_to :user

  def self.again_buy?(user_id, race_id)
    where(user_id: user_id).where(race_id: race_id).present?
  end
end
