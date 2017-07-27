require 'rails_helper'

RSpec.describe '/v10/players', :type => :request do
  let(:player) do
    FactoryGirl.create(:player, name: 'poker_1')
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end

  context '关注牌手' do
    it '关注成功' do
      post v10_player_follows_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
    end

    it '重复关注，只创建一个记录' do
      post v10_player_follows_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      post v10_player_follows_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      follows = PlayerFollow.where(player_id: player.id, user_id: user.id)
      expect(follows.size).to eq(1)
    end
  end
end