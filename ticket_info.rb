=begin
+---------------------------+----------+------+-----+---------+----------------+
| Field                     | Type     | Null | Key | Default | Extra          |
+---------------------------+----------+------+-----+---------+----------------+
| id                        | int(11)  | NO   | PRI | NULL    | auto_increment |
| race_id                   | int(11)  | YES  | MUL | NULL    |                |
| total_number              | int(11)  | YES  |     | 0       |                |
| e_ticket_number           | int(11)  | YES  |     | 0       |                |
| entity_ticket_number      | int(11)  | YES  |     | 0       |                |
| e_ticket_sold_number      | int(11)  | YES  |     | 0       |                |
| entity_ticket_sold_number | int(11)  | YES  |     | 0       |                |
| created_at                | datetime | NO   |     | NULL    |                |
| updated_at                | datetime | NO   |     | NULL    |                |
+---------------------------+----------+------+-----+---------+----------------+
=end
class TicketInfo < ApplicationRecord
  belongs_to :race

  def e_ticket_sold_out?
    e_ticket_sold_number >= e_ticket_number
  end

  def sold_out?
    e_ticket_sold_number >= e_ticket_number && entity_ticket_sold_number >= entity_ticket_number
  end

  def increment_with_lock!(attribute, by = 1)
    self[attribute] += by
    self.save!
  end

  def decrement_with_lock!(attribute, by = 1)
    increment_with_lock!(attribute, -by)
  end

  def surplus_e_ticket
    e_ticket_number - e_ticket_sold_number
  end

  def surplus_entity_ticket
    entity_ticket_number - entity_ticket_sold_number
  end
end
