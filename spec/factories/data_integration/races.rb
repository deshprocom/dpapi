module DataIntegration
  module Races
    def ac_us001_001
      FactoryGirl.create(:race_desc)
    end

    def ac_us003_001
      FactoryGirl.create(:race, begin_date: 1.days.since.strftime('%Y-%m-%d'), status: 0)
    end

    def ac_us003_002
      FactoryGirl.create(:race, begin_date: 2.days.since.strftime('%Y-%m-%d'), status: 1)
    end

    def ac_us003_003
      FactoryGirl.create(:race, begin_date: 3.days.since.strftime('%Y-%m-%d'), status: 2)
    end

    def ac_us003_004
      FactoryGirl.create(:race, begin_date: 4.days.since.strftime('%Y-%m-%d'), status: 3)
    end

    def init_recent_races
      9.times { FactoryGirl.create(:race) }
      FactoryGirl.create(:race,
                         begin_date: 3.days.ago.strftime('%Y-%m-%d'),
                         end_date: 3.days.since.strftime('%Y-%m-%d'),
                         status: 1)
      FactoryGirl.create(:race,
                         begin_date: 8.days.ago.strftime('%Y-%m-%d'),
                         end_date: 5.days.ago.strftime('%Y-%m-%d'))
      FactoryGirl.create(:race, status: 2)
      FactoryGirl.create(:race, status: 3)
    end

    def init_followed_or_ordered_races(user)
      first_race  = FactoryGirl.create(:race,
                                       begin_date: 3.days.ago.strftime('%Y-%m-%d'),
                                       end_date: 3.days.since.strftime('%Y-%m-%d'),
                                       status: 1)
      second_race = FactoryGirl.create(:race, begin_date: 2.days.ago.strftime('%Y-%m-%d'),)
      third_race = FactoryGirl.create(:race)
      FactoryGirl.create(:race_follow, race_id: first_race.id, user_id: user.id)
      FactoryGirl.create(:race_order, race_id: second_race.id, user_id: user.id)
      FactoryGirl.create(:race_order, race_id: third_race.id, user_id: user.id)
      FactoryGirl.create(:race_follow, race_id: third_race.id, user_id: user.id)
    end

    def init_races
      20.times { FactoryGirl.create(:race) }
    end

    def followed_and_ordered_race(user)
      race_desc = FactoryGirl.create(:race_desc)
      FactoryGirl.create(:race_order, race_id: race_desc.race_id, user_id: user.id)
      FactoryGirl.create(:race_follow, race_id: race_desc.race_id, user_id: user.id)
      race_desc
    end
  end
end
