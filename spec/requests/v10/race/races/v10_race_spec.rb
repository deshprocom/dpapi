require 'rails_helper'

RSpec.describe '/v10/u/:u_id/races/:id', :type => :request do
  include AcFactory::Races

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

  context '当赛事状态为未开始或进行中或已结束或已关闭' do
    it '返回的赛事状态应为 未开始' do
      race_id = ac_us003_001.id
      get v10_u_race_url(0, race_id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']
      expect(race['status']).to  eq(0)
    end

    it '返回的赛事状态应为 进行中' do
      race_id = ac_us003_002.id
      get v10_u_race_url(0, race_id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']
      expect(race['status']).to  eq(1)
    end

    it '返回的赛事状态应为 已结束' do
      race_id = ac_us003_003.id
      get v10_u_race_url(0, race_id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']
      expect(race['status']).to  eq(2)
    end

    it '返回的赛事状态应为 已终止' do
      race_id = ac_us003_004.id
      get v10_u_race_url(0, race_id),
          headers: http_headers

      json = JSON.parse(response.body)
      race = json['data']
      expect(race['status']).to  eq(3)
    end
  end

  context '当用户已经购票和已关注时' do
    it '应返回已购票，已关注的状态' do
      race_desc = followed_and_ordered_race(user)
      get v10_u_race_url(user.user_uuid, race_desc.race_id),
          headers: http_headers

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      race = json['data']
      expect(race['followed']).to  be_truthy
      expect(race['ordered']).to   be_truthy
    end
  end
end