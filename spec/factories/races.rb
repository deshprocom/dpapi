FactoryGirl.define do
  factory :race do
    sequence(:name) { |n| "race_name#{n}" }
    sequence(:logo) { |n| "/logos/#{n}" }
    sequence(:prize) { |n| "100_000_#{n}" }
    sequence(:location) { |n| "location_#{n}" }
    sequence(:start_time) { Random.rand(1..9).days.since }
    sequence(:end_time)   { Random.rand(11..19).days.since }
  end
end
