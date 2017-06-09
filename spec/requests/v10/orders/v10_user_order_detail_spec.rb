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
  let!(:race) { FactoryGirl.create(:race) }
  let!(:ticket) { FactoryGirl.create(:ticket, race: race, status: 'selling') }
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, ticket: ticket) }
  let!(:create_orders) do
    Services::Orders::CreateOrderService.call(race, ticket, user, e_ticket_params)
  end

  context '获取用户某个订单详情' do
    context "传不存在的订单编号" do
      it '应该返回code: 1100006' do
        get v10_user_order_url(user.user_uuid, 123),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['code']).to eq(1100006)
      end
    end

    context "存在的订单编号" do
      it '应该返回订单数据' do
        get v10_user_order_url(user.user_uuid, PurchaseOrder.first.order_number),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['data']['race_info'].class).to eq(Hash)
        expect(json['data']['order_info'].class).to eq(Hash)
      end
    end
  end
end