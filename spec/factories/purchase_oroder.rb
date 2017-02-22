FactoryGirl.define do
  factory :purchase_order do
    association :race
    association :user
    association :ticket
    email 'test@gmail.com'
    address '深圳市福田区卓越大厦'
    consignee 'xiaoming'
    mobile '13428725222'
  end
end
