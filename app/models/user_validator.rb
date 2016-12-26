class UserValidator
  include UserUniqueValidator
  include EmailValidator
  include MobileValidator
  include PasswordValidator
end