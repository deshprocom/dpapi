# +------------+--------------+------+-----+---------+----------------+
# | Field      | Type         | Null | Key | Default | Extra          |
# +------------+--------------+------+-----+---------+----------------+
# | id         | int(11)      | NO   | PRI | NULL    | auto_increment |
# | race_id    | int(11)      | YES  | MUL | NULL    |                |
# | name       | varchar(100) | YES  |     | NULL    |                |
# | price      | int(11)      | YES  |     | 0       |                |
# | status     | varchar(30)  | YES  |     | selling |                |
# | created_at | datetime     | NO   |     | NULL    |                |
# | updated_at | datetime     | NO   |     | NULL    |                |
# +------------+--------------+------+-----+---------+----------------+

class RaceTicket < ApplicationRecord
  belongs_to :race

end
