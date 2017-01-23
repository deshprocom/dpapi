require 'rails_helper'

RSpec.describe '/v10/u/:u_id/recent_races', :type => :request do
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

  context '给定不存在即将到来的赛事，当获取赛事时' do
    it '应当返回空数组' do
      get v10_u_recent_races_url(0),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size.zero?).to be_truthy
    end
  end

  context '给定存在10条即将到来的赛事，当获取赛事时' do
    it '应当返回最近的5条赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
           headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(5)
      races.each do |race|
        expect(race['name'].class).to       eq(String)
        expect(race['logo'].class).to       eq(String)
        expect(race['prize'].class).to      eq(Fixnum)
        expect(race['location'].class).to   eq(String)
        expect(race['begin_date'].class).to eq(String)
        expect(race['end_date'].class).to   eq(String)
        expect(race['status'].class).to     eq(Fixnum)
        expect( %w(true false) ).to    include(race['followed'].to_s)
        expect( %w(true false) ).to    include(race['ordered'].to_s)
      end
    end
  end

  context '给定存在10条即将到来的赛事，当获取8条赛事时' do
    it '应当返回最近的8条赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers,
          params: {number: 8}

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(8)
    end
  end

  context '给定存在10条即将到来和1条5天前结束的赛事，当获取赛事时' do
    it '那么赛事的排序应为开始日期的正序，并结束日期都是大于或等于当天的' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers,
          params: {number: 10}

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races.class).to      eq(Array)
      expect(races.size).to       eq(10)
      races.each_with_index do |race, index|
        expect(Time.parse(race['end_date']) >= Time.now.beginning_of_day).to be_truthy
        next if index.zero?

        first_begin_date = Time.parse(races[index - 1]['begin_date'])
        second_begin_date = Time.parse(race['begin_date'])
        expect(second_begin_date >= first_begin_date).to be_truthy
      end
    end
  end

  context '给定存在进行中，已结束，未开始，已终止这四种状态的赛事，当获取赛事时' do
    it '那么只返回进行中与未开始状态的赛事' do
      init_recent_races
      get v10_u_recent_races_url(0),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['status']).to  eq(1)
      expect(races[1]['status']).to  eq(0)
      races.each do |race|
        expect([2,3]).not_to include(race['status'])
      end
    end

  end

  context '给定存在第一条赛事已关注，第二条赛事已购票, 第三条为已关注，已购票' do
    it '那么应返回正确状态的赛事列表' do
      init_followed_or_ordered_races(user)
      get v10_u_recent_races_url(user.user_uuid),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      races = json['data']['items']
      expect(races[0]['followed']).to  be_truthy
      expect(races[0]['ordered']).to   be_falsey
      expect(races[1]['followed']).to  be_falsey
      expect(races[1]['ordered']).to   be_truthy
      expect(races[2]['followed']).to  be_truthy
      expect(races[2]['ordered']).to   be_truthy
    end
  end
end