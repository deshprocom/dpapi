require 'rails_helper'

RSpec.describe '/v10/races/race_id/sub_races', type: :request do

  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end
  let(:user) { FactoryGirl.create(:user) }
  let(:init_sub_races) do
    main_race = FactoryGirl.create(:race)
    5.times { FactoryGirl.create(:race, parent: main_race) }
    main_race
  end

  context '给定存在20条赛事，当获取10条赛事时' do
    it '应当返回10条赛事，数据格式应正常' do
      main_race = init_sub_races
      get v10_race_sub_races_url(main_race.id), headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(5)
      races.each do |race|
        expect(race['race_id'].class).to    eq(Fixnum)
        expect(race['name'].class).to       eq(String)
        expect(race['prize'].class).to      eq(String)
        expect(race['ticket_price'].class).to eq(Fixnum)
        expect(race['blind'].class).to      eq(String)
        expect(race['location'].class).to   eq(String)
        expect(race['begin_date'].class).to eq(String)
        expect(race['end_date'].class).to   eq(String)
        expect(race.has_key?('roy')).to     be_truthy
      end
    end
  end
end