require 'rails_helper'

RSpec.describe 'v10_news_type', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end

  # 初始化10条资讯
  let(:init_types) do
    10.times { FactoryGirl.create(:info_type) }
  end

  describe '不存在资讯类别' do
    it "should return empty array" do
      get v10_news_types_url,
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(0)
    end
  end

  describe '存在资讯类别， 且第一，二个资讯类别未发布' do
    it "should return array size 8" do
      init_types
      InfoType.first.update(published: false)
      InfoType.second.update(published: false)
      get v10_news_types_url,
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(8)
      expect(json['data']['items'][0]['id']).to be_truthy
      expect(json['data']['items'][0]['name']).to be_truthy
    end
  end
end