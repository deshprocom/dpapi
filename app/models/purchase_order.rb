class PurchaseOrder < ApplicationRecord
  belongs_to :user
  belongs_to :race
  belongs_to :ticket
end
