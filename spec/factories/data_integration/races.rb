module DataIntegration
  module Races
    def init_ten_recent_races
      10.times { FactoryGirl.create(:race) }
    end
  end
end
