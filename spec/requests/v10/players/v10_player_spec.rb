require 'rails_helper'

RSpec.describe '/v10/players/:id', :type => :request do
  let(:player) { FactoryGirl.create(:player, name: 'poker_1') }
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: "application/json",
        HTTP_ACCEPT: "application/json",
        HTTP_X_DP_CLIENT_IP: "localhost",
        HTTP_X_DP_APP_KEY: "467109f4b44be6398c17f6c058dfa7ee"
    }
  end

  context "没有该牌手" do
    it "应当返回 code: 1100006 (NOT_FOUND)" do
      get v10_player_url('not_exist'),
           headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100006)
    end
  end

  context "存在该牌手" do
    it "应当返回 code: 0" do
      get v10_player_url(player.player_id),
           headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json["data"]["name"]).to eq('poker_1')
      expect(json["data"]["avatar"]).to be_truthy
      expect(json["data"]["ranking"]).to be_truthy
      expect(json["data"]["country"]).to eq('中国')
      expect(json["data"]["dpi_total_earning"]).to eq('200')
      expect(json["data"]["dpi_total_score"]).to eq('404')
      expect(json["data"]["memo"]).to eq('测试')

      expect(get(json["data"]["avatar"])).to eq(200)
    end
  end
end