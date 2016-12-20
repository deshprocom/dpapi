class User < ApplicationRecord
  include UserFinders
  include UserUniqueValidator
  include UserNameGenerator

  acts_as_cached(version: 1, expires_in: 1.week)
end
