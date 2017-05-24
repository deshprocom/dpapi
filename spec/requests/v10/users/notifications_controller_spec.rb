require 'rails_helper'

RSpec.describe '/v10/users/:user_id/notifications', :type => :request do
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

  context '获取消息列表' do
    it '返回空列表' do
      get v10_user_notifications_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(json['data']['notifications'].size).to eq(0)
    end

    it '应返回相应的消息列表' do
      order = FactoryGirl.create(:purchase_order, user: user)
      order.paid!
      get v10_user_notifications_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      notifications = json['data']['notifications']
      expect(notifications.size).to eq(2)
      notifications.each do |notification|
        expect(notification['id'] > 0).to be_truthy
        expect(notification['notify_type']).to eq('order')
        expect(notification['title'].blank?).to be_falsey
        expect(notification['content'].blank?).to be_falsey
        expect(notification['created_at'] > 0).to be_truthy
      end
    end
  end
end