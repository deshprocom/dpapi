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
  let!(:ticket_info) { FactoryGirl.create(:ticket_info, race: race) }
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
  let(:create_order) do
    Services::Orders::CreateOrderService.call(race, user, e_ticket_params)
    user.orders.find_by_race_id(race.id)
  end
  let(:other_people_order) do
    other_user = FactoryGirl.create(:user, user_uuid: 'test123_geek',
                                    user_name: 'Geek',
                                    mobile: '13655667766',
                                    email: 'test2@deshpro.com')
    FactoryGirl.create(:user_extra, user: other_user, status: 'passed')
    Services::Orders::CreateOrderService.call(race, other_user, e_ticket_params)
    other_user.orders.find_by_race_id(race.id)
  end

  context '取消订单成功' do
    it '订单状态变成canceled, 释放一张票' do
      order = create_order
      ticket = user.tickets.find_by_race_id(race.id)
      expect(order.status).to     eq('unpaid')
      old_number = ticket_info.reload.e_ticket_sold_number

      post v10_user_order_cancel_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      order.reload
      ticket.reload
      new_number = ticket_info.reload.e_ticket_sold_number
      expect(order.status).to eq('canceled')
      expect(old_number - new_number).to eq(1)
    end

    it 'ticket的canceled应为true' do
      order = create_order
      ticket = user.tickets.find_by_race_id(race.id)
      expect(ticket.canceled).to  be_falsey

      post v10_user_order_cancel_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)

      ticket.reload
      expect(ticket.canceled).to be_truthy
    end

    it '当前购票状态为sold_out, 释放一张票后，应改变状态为selling' do
      ticket_info.update(e_ticket_number: 1)
      order = create_order
      expect(race.reload.ticket_status).to  eq('sold_out')

      post v10_user_order_cancel_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(0)
      expect(race.reload.ticket_status).to  eq('selling')
    end
  end

  context '取消订单失败' do
    it '不能取消非本人的订单' do
      order = other_people_order
      post v10_user_order_cancel_index_url(user.user_uuid, order.order_number),
           headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to   eq(1100006)
    end

    it '订单状态不为 unpaid,不能取消' do
      order = create_order
      %w(canceled paid completed).each do |status|
        order.update(status: status)
        post v10_user_order_cancel_index_url(user.user_uuid, order.order_number),
             headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['code']).to   eq(1110000)
      end
    end
  end
end
