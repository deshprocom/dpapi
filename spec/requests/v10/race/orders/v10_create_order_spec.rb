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
  let!(:race) { FactoryGirl.create(:race, ticket_status: 'selling') }
  let!(:race_info) { FactoryGirl.create(:ticket_info, race: race) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_extra) { FactoryGirl.create(:user_extra, user: user, status: 'passed') }
  let(:shipping_address) { FactoryGirl.create(:shipping_address, user: user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end
  let(:e_ticket_params) do
    {
        ticket_type: 'e_ticket',
        email: 'test@gmail.com',
    }
  end


  context '购票成功' do
    it '成功购买电子票' do
      race_id = race.id
      post v10_race_orders_url(race_id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket = user.tickets.find_by(race_id: race_id)
      order = user.orders.find_by(ticket_id: ticket.id)
      expect(ticket).to be_truthy
      expect(order).to be_truthy
      expect(order.status).to  eq('unpaid')
      expect(ticket.status).to eq('unpaid')
    end

    it '购买成功电子票， 电子票已售票数应加1' do
      old_sold_num = race_info.e_ticket_sold_number
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      race_info.reload
      expect(race_info.e_ticket_sold_number - old_sold_num).to   eq(1)
    end

    it '当实体票与电子票都售完，应改变状态为 sold_out' do
      race_info.update(e_ticket_sold_number: 49)
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      race.reload
      expect(race.ticket_status).to eq('sold_out')
    end


    it '成功购买实体票'
    it '购买成功实体票， 实体票已售票数应加1'
  end

  context '购票失败' do
    it '限购一张，重复购票' do
      result = Services::Races::OrderGenerator.call(race, user, e_ticket_params)
      expect(result.code).to   eq(0)

      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100039)
    end

    it '用户没有实名信息' do
      user.user_extra.destroy
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100051)
    end

    it '售票状态不为selling' do
      race.update(ticket_status: 'end')
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100038)
    end

    it '购买电子票，电子票已票完' do
      race_info.update(e_ticket_sold_number: 50)
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100040)
    end

    it '购买电子票，email错误' do
      post v10_race_orders_url(race.id),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token),
           params: e_ticket_params.merge(email: '1212')

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100004)
    end

    it '购买实体票，实体票已票完'
  end
end