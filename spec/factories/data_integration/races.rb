module DataIntegration
  module Races
    def init_recent_races
      9.times { FactoryGirl.create(:race) }
      FactoryGirl.create(:race, start_time: 3.days.ago, end_time: 3.days.since, status: 1)
      FactoryGirl.create(:race, start_time: 8.days.ago, end_time: 5.days.ago)
      FactoryGirl.create(:race, status: 2)
      FactoryGirl.create(:race, status: 3)
    end

    def init_followed_or_ordered_races(user)
      first_race  = FactoryGirl.create(:race, start_time: 3.days.ago, end_time: 3.days.since, status: 1)
      second_race = FactoryGirl.create(:race)
      FactoryGirl.create(:race_follow, race_id: first_race.id, user_id: user.id)
      FactoryGirl.create(:race_order, race_id: second_race.id, user_id: user.id)
    end
  end
end
