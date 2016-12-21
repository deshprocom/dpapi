class UserValidator
  include UserUniqueValidator
  include EmailValidator
  include MobileValidator
end