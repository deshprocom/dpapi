class Affiliate < ApplicationRecord
  has_many :affiliate_apps, dependent: :destroy
end
