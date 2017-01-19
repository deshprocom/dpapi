# +------------+----------+------+-----+---------+----------------+
# | Field      | Type     | Null | Key | Default | Extra          |
# +------------+----------+------+-----+---------+----------------+
# | id         | int(11)  | NO   | PRI | NULL    | auto_increment |
# | user_id    | int(11)  | YES  | MUL | NULL    |                |
# | race_id    | int(11)  | YES  | MUL | NULL    |                |
# | created_at | datetime | NO   |     | NULL    |                |
# | updated_at | datetime | NO   |     | NULL    |                |
# +------------+----------+------+-----+---------+----------------+
class RaceFollow < ApplicationRecord
  belongs_to :user
  belongs_to :race
end
