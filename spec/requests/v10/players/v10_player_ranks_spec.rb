require 'rails_helper'

RSpec.describe '/v10/players/:id/ranks', :type => :request do
  let!(:player) do
    FactoryGirl.create(:player, name: 'poker_1')
  end
  let(:race) { FactoryGirl.create(:race) }
  let(:race_ranks) do
    FactoryGirl.create(:race_rank ,race: race, player: player)
  end
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end

  context '获取牌手的战绩列表' do
    it '返回空列表' do
      get v10_player_ranks_url(player.player_id),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['data']).to eq([])
    end

    it '获取列表' do
      race_ranks
      get v10_player_ranks_url(player.player_id),
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      ranks = json['data']
      expect(ranks.size).to eq(1)
    end
  end
end