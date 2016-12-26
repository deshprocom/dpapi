FactoryGirl.define do
  factory :user do
    user_uuid 'uuid_123456789'
    user_name 'Ricky'
    nick_name 'Ricky'
    gender 2
    password_salt 'abcdef'
    password ::Digest::MD5.hexdigest('test123abcdef')
    mobile '18018001880'
    email 'ricky@deshpro.com'
    reg_date Time.now
    last_visit Time.now
  end
end