class PurchaseOrder < ApplicationRecord
  include NumberGenerator

  belongs_to :user
  belongs_to :race
  belongs_to :ticket
  has_one :snapshot, class_name: OrderSnapshot

  validates_presence_of :user, :race, :ticket_type, :ticket, :order_number, :price, :original_price

  after_initialize do
    self.order_number ||= self.class.unique_number
  end

  after_create do
    race.sold_a_ticket
    create_snapshot(race.to_snapshot)
  end
end
