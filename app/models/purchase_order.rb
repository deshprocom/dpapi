=begin
+----------------+--------------+------+-----+----------+----------------+
| Field          | Type         | Null | Key | Default  | Extra          |
+----------------+--------------+------+-----+----------+----------------+
| id             | int(11)      | NO   | PRI | NULL     | auto_increment |
| user_id        | int(11)      | YES  | MUL | NULL     |                |
| ticket_id      | int(11)      | YES  | MUL | NULL     |                |
| race_id        | int(11)      | YES  | MUL | NULL     |                |
| ticket_type    | varchar(30)  | YES  |     | e_ticket |                |
| email          | varchar(255) | YES  |     | NULL     |                |
| address        | varchar(255) | YES  |     | NULL     |                |
| consignee      | varchar(50)  | YES  |     | NULL     |                |
| mobile         | varchar(50)  | YES  |     | NULL     |                |
| order_number   | varchar(30)  | YES  | UNI | NULL     |                |
| price          | int(11)      | NO   |     | NULL     |                |
| original_price | int(11)      | NO   |     | NULL     |                |
| status         | varchar(30)  | YES  | MUL | unpaid   |                |
| created_at     | datetime     | NO   |     | NULL     |                |
| updated_at     | datetime     | NO   |     | NULL     |                |
+----------------+--------------+------+-----+----------+----------------+
=end
class PurchaseOrder < ApplicationRecord
  include NumberGenerator

  belongs_to :user
  belongs_to :race
  belongs_to :ticket
  has_one :snapshot, class_name: OrderSnapshot

  validates :race, :order_number,
            presence: true

  after_initialize do
    self.order_number ||= self.class.unique_number
  end

  after_create do
    race.sold_a_ticket
    create_snapshot(race.to_snapshot)
  end
end
