class Ticket < ApplicationRecord
  belongs_to :race
  belongs_to :user

  def self.again_buy?(user_id, race_id)
    where(user_id: user_id).where(race_id: race_id).present?
  end
end
