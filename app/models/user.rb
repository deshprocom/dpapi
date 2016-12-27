class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator
  include UserCreator

  acts_as_cached(version: 1, expires_in: 1.week)

  def touch_visit!
    self.last_visit = Time.now
    self.save
  end

end
