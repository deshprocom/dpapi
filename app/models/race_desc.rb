# +------------+----------+------+-----+---------+----------------+
# | Field      | Type     | Null | Key | Default | Extra          |
# +------------+----------+------+-----+---------+----------------+
# | id         | int(11)  | NO   | PRI | NULL    | auto_increment |
# | races_id   | int(11)  | YES  | MUL | NULL    |                |
# | describe   | text     | YES  |     | NULL    |                |
# | created_at | datetime | NO   |     | NULL    |                |
# | updated_at | datetime | NO   |     | NULL    |                |
# +------------+----------+------+-----+---------+----------------+
class RaceDesc < ApplicationRecord
end
