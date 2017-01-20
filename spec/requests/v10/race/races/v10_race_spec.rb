require 'rails_helper'

RSpec.describe '/v10/u/:u_id/races/:id', :type => :request do
  include DataIntegration::Races

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
  let(:race_desc) { FactoryGirl.create(:race_desc) }

  context '当访问不存在赛事详情时' do
    it '应当返回不存在相应的数据' do
      get v10_u_race_url(0, 'nonexistent'),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(1100006)
    end
  end

  context '当访问赛事详情时' do
    it '应当返回相应的数据' do
      get v10_u_race_url(0, race_desc.race_id),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      race = json['data']
      expect(race['description']).to eq(race_desc.description)
      expect(race['name']).to        eq(race_desc.race.name)
      expect(race['seq_id']).to      eq(race_desc.race.seq_id)
      expect(race['logo']).to        eq(race_desc.race.logo)
      expect(race['prize']).to       eq(race_desc.race.prize)
      expect(race['location']).to    eq(race_desc.race.location)
      expect(race['begin_date']).to  eq(race_desc.race.begin_date.to_s)
      expect(race['end_date']).to    eq(race_desc.race.end_date.to_s)
      expect(race['status']).to      eq(race_desc.race.status)
      expect( %w(true false) ).to    include(race['followed'].to_s)
      expect( %w(true false) ).to    include(race['ordered'].to_s)
    end
  end

end