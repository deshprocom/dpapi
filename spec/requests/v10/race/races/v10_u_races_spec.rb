require 'rails_helper'

RSpec.describe '/v10/u/:u_id/races', :type => :request do
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

  context '给定存在10条即将到来的赛事，当获取5条赛事时' do
    it '应当返回最近的5条赛事' do
      init_ten_recent_races
      get v10_u_races_url(0),
           headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      races.each do |race|
        expect(race['name'].class).to       eq(String)
        expect(race['logo'].class).to       eq(String)
        expect(race['prize'].class).to      eq(Fixnum)
        expect(race['location'].class).to   eq(String)
        expect(race['start_time'].class).to eq(Fixnum)
        expect(race['end_time'].class).to   eq(Fixnum)
        expect(race['status'].class).to     eq(Fixnum)
        expect(race['followed'].class).to   eq(String)
        expect(race['ordered'].class).to    eq(String)
      end
    end
  end
end