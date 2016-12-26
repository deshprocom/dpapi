class AffiliateApp < ApplicationRecord

  include AffiliateAppCacheable

  belongs_to :affiliate

  acts_as_cached :version => 1, :expires_in => 1.week

  def self.by_app_key(app_key)
    self.fetch_by_uniq_keys(app_key: app_key)
  end
end
