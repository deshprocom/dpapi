class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :ticket
  has_one :snapshot, class_name: OrderSnapshot
end

