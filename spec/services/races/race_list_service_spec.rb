require 'rails_helper'

RSpec.describe Services::Account::RaceListService do
  let!(:race) { FactoryGirl.create(:race) }

  context "传入了seq_id，那么传入正确的seq_id应该可以获取到数据" do
    it "should return code 0" do
      params = {
          seq_id:        race.seq_id,
          page_size:     '2',
          operator:        'down'
      }
      race_list_service = Services::Account::RaceListService
      api_result = race_list_service.call(0, params)
      expect(api_result.code).to eq(0)
    end
  end

  context "如果没有传入seq_id, 也没有传入begin_date" do
    it "should return code 1100001" do
      params = {
          page_size:         '2',
          operator:          'down'
      }
      race_list_service = Services::Account::RaceListService
      api_result = race_list_service.call(0, params)
      expect(api_result.code).to eq(1100001)
    end
  end

  context "如果没有传入seq_id, 也没有传入begin_date" do
    it "should return code 0" do
      params = {
          begin_date:        race.begin_date,
          page_size:         '2',
          operator:          'down'
      }
      race_list_service = Services::Account::RaceListService
      api_result = race_list_service.call(0, params)
      expect(api_result.code).to eq(0)
    end
  end
end