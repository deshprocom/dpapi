FactoryGirl.define do
  factory :user_extra do
    user_id           'user_001'
    real_name         '王石'
    cert_type         'chinese_id'
    cert_no           '611002199301146811'
    memo              '身份证'
    status            'pending'
  end
end