FactoryGirl.define do
  factory :ticket do
    association :race
    title   '机票 + 赛事门票'
    price   10000
    original_price   10000
    ticket_class   'race_extra'
  end
end
