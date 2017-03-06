require 'rails_helper'

RSpec.describe '/v10/races/:race_id/orders', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:e_ticket_params) do
    {
        ticket_type: 'e_ticket',
        email: 'test@gmail.com',
    }
  end

  let!(:init_orders) do
    20.times { FactoryGirl.create(:race, ticket_status: 'selling') }
    Race.all.map do |race_item|
      FactoryGirl.create(:ticket_info, race: race_item)
      Services::Races::CreateOrderService.call(race_item, user, e_ticket_params)
    end
  end

  context '获取订单列表' do
    context "不传任何参数" do
      it '应该最多返回10条数据' do
        get v10_user_orders_url(user.user_uuid),
             headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['data']['next_id']).to be_truthy
        numbers = json['data']['items'].length
        expect(numbers).to   eq(10)
      end
    end

    context "传入参数page_size = 1" do
      it '那么只返回一条数据' do
        get v10_user_orders_url(user.user_uuid),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
            params: { page_size: 1 }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['data']['next_id']).to be_truthy
        numbers = json['data']['items'].length
        expect(numbers).to   eq(1)
      end
    end

    context "status = unpaid, page_size =2" do
      it '那么只返回一条数据' do
        get v10_user_orders_url(user.user_uuid),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
            params: { page_size: 2, status: 'unpaid' }
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['data']['next_id']).to be_truthy
      end
    end

    context "page_size = 2, status = unpaid, next_id = " do
      it '那么只返回一条数据' do
        get v10_user_orders_url(user.user_uuid),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
            params: { page_size: 2, status: 'unpaid' }
        json = JSON.parse(response.body)
        next_id = json['data']['next_id']
        get v10_user_orders_url(user.user_uuid),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
            params: { page_size: 2, status: 'unpaid', next_id: next_id }
        expect(response).to have_http_status(200)
        json_data = JSON.parse(response.body)
        expect(json_data['data']['next_id']).to be_truthy
      end
    end
  end
end