require 'rails_helper'

RSpec.describe '/v10/users/:user_id/followed_players', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
      ACCEPT: "application/json",
      HTTP_ACCEPT: "application/json",
      HTTP_X_DP_CLIENT_IP: "localhost",
      HTTP_X_DP_APP_KEY: "467109f4b44be6398c17f6c058dfa7ee"
    }
  end
  let!(:user) { FactoryGirl.create(:user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:player) do
    FactoryGirl.create(:player, name: 'poker_1')
  end

  context '获取消息列表' do
    it '返回空列表' do
      get v10_user_followed_players_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['followed_players'].size).to eq(0)
    end

    it '返回相应的列表' do
      post v10_player_follow_url(player.player_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)

      get v10_user_followed_players_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['followed_players'].size).to eq(1)
      next_id = json['data']['next_id']

      get v10_user_followed_players_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
          params: { next_id: next_id }

      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['followed_players'].size).to eq(0)
    end
  end
end