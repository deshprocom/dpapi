=begin
+-----------------+--------------+------+-----+------------+----------------+
| Field           | Type         | Null | Key | Default    | Extra          |
+-----------------+--------------+------+-----+------------+----------------+
| id              | int(11)      | NO   | PRI | NULL       | auto_increment |
| user_id         | int(11)      | YES  | MUL | NULL       |                |
| race_id         | int(11)      | YES  | MUL | NULL       |                |
| ticket_infos_id | int(11)      | YES  | MUL | NULL       |                |
| ticket_type     | varchar(30)  | YES  |     | e_ticket   |                |
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
