FactoryGirl.define do
  factory :race_ticket do
    association :race
    sequence(:name) { |n| "2017APT启航站第#{n}场门票" }
    price   10000
    status 'selling'
  end
end
