FactoryGirl.define do
  factory :ticket do
    association :race
    association :user
  end
end
