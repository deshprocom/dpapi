require 'rails_helper'

RSpec.describe 'v10_news_search_index', :type => :request do
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
  let(:init_news) do
    10.times { FactoryGirl.create(:info) }
  end

  describe '不存在资讯' do
    it "should return empty array" do
      get v10_news_search_index_url,
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(0)
      expect(json['data']['next_id']).to eq('0')
    end
  end

  describe '存在资讯，第一条赛事为非发布状态' do
    it "should return array size 9" do
      init_news
      Info.first.update(published: false)
      get v10_news_search_index_url,
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(9)
      expect(json['data']['next_id']).to eq('10')
    end
  end

  describe '存在资讯，第一,二条赛事对应的类别为非发布状态' do
    it "should return array size 9" do
      init_news
      Info.first.info_type.update(published: false)
      Info.second.info_type.update(published: false)
      get v10_news_search_index_url,
          headers: http_headers
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(8)
      expect(json['data']['next_id']).to eq(Info.last.id.to_s)
    end
  end

  describe '存在资讯，查询关键字为test_8的赛事' do
    it "should return array size 1" do
      init_news
      get v10_news_search_index_url,
          headers: http_headers,
          params: { keyword: Info.second.title }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(1)
      expect(json['data']['items'][0]['title']).to eq(Info.second.title)
      expect(json['data']['items'][0]['date']).to be_truthy
      expect(json['data']['items'][0]['source_type']).to be_truthy
      expect(json['data']['items'][0]['source']).to be_truthy
      expect(json['data']['next_id']).to be_truthy
    end
  end

  describe '存在资讯，指定获取条数' do
    it "should return array size 4" do
      init_news
      get v10_news_search_index_url,
          headers: http_headers,
          params: { page_size: '4' }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['items'].size).to eq(4)
      expect(json['data']['items'][0]['title']).to be_truthy
      expect(json['data']['items'][0]['date']).to be_truthy
      expect(json['data']['items'][0]['source_type']).to be_truthy
      expect(json['data']['items'][0]['source']).to be_truthy
      expect(json['data']['next_id']).to be_truthy
    end
  end
end