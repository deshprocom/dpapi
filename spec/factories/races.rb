FactoryGirl.define do
  factory :race do
    sequence(:name) { |n| "race_name#{n}" }
    sequence(:logo) { |n| "/logos/#{n}" }
    sequence(:prize) { |n| "100_000_#{n}" }
    sequence(:location) { |n| "location_#{n}" }
    start_time 5.days.since
    end_time   8.days.since
  end
end
