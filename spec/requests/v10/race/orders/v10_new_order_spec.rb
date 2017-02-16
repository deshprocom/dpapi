require 'rails_helper'

RSpec.describe '/v10/races/:race_id/new_order', :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: 'application/json',
        HTTP_ACCEPT: 'application/json',
        HTTP_X_DP_CLIENT_IP: 'localhost',
        HTTP_X_DP_APP_KEY: '467109f4b44be6398c17f6c058dfa7ee'
    }
  end
  let!(:race_info) { FactoryGirl.create(:ticket_info) }
  let!(:user) { FactoryGirl.create(:user) }
  let(:shipping_address) { FactoryGirl.create(:shipping_address, user: user) }
  let(:access_token) do
    AppAccessToken.jwt_create('18ca083547bb164b94a0f89a7959548b', user.user_uuid)
  end

  context '获取购票界面所需的数据' do
    context '当用户有相应的address时' do
      it '应当返回相应的数据中应有address信息' do
        shipping_address
        get v10_race_new_order_url(race_info.race_id),
            headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)

        race = json['data']['race']
        expect(race.key? 'id').to           be_truthy
        expect(race.key? 'name').to         be_truthy
        expect(race.key? 'location').to     be_truthy
        expect(race.key? 'begin_date').to   be_truthy
        expect(race.key? 'end_date').to     be_truthy
        expect(race.key? 'ticket_price').to be_truthy

        ticket_info = json['data']['ticket_info']
        expect(ticket_info.key? 'total_number').to               be_truthy
        expect(ticket_info.key? 'e_ticket_number').to            be_truthy
        expect(ticket_info.key? 'entity_ticket_number').to       be_truthy
        expect(ticket_info.key? 'e_ticket_sold_number').to       be_truthy
        expect(ticket_info.key? 'entity_ticket_sold_number').to  be_truthy

        shipping_address = json['data']['shipping_address']
        expect(shipping_address.key? 'consignee').to      be_truthy
        expect(shipping_address.key? 'mobile').to         be_truthy
        expect(shipping_address.key? 'address_detail').to be_truthy
        expect(shipping_address.key? 'post_code').to      be_truthy
      end
    end
  end
end