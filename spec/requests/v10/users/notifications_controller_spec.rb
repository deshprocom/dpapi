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

    it '应返回相应的订单类型消息列表' do
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
        expect(notification['color_type']).to eq('success')
        expect(notification['title'].blank?).to be_falsey
        expect(notification['content'].blank?).to be_falsey
        expect(notification['order_number'].blank?).to be_falsey
        expect(notification['image'].blank?).to be_falsey
        expect(notification['created_at'] > 0).to be_truthy
      end
    end

    it '应返回相应的实名认证类型消息列表' do
      user_extra = FactoryGirl.create(:user_extra, user: user)
      user_extra.passed!
      user_extra.failed!
      get v10_user_notifications_url(user.user_uuid),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      notifications = json['data']['notifications']
      expect(notifications.size).to eq(2)
      expect(notifications[0]['id'] > 0).to be_truthy
      expect(notifications[0]['notify_type']).to eq('certification')
      expect(notifications[0]['color_type']).to eq('failure')
      expect(notifications[0]['title'].blank?).to be_falsey
      expect(notifications[0]['content'].blank?).to be_falsey
      expect(notifications[0]['created_at'] > 0).to be_truthy

      expect(notifications[1]['color_type']).to eq('success')
    end
  end

  context '删除消息' do
    it '删除成功' do
      user_extra = FactoryGirl.create(:user_extra, user: user)
      user_extra.passed!
      notifications = user.notifications
      expect(notifications.size).to eq(1)
      delete v10_user_notification_url(user.user_uuid, notifications[0].id),
          headers: http_headers.merge(HTTP_X_DP_ACCESS_TOKEN: access_token)

      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['code']).to eq(0)
      expect(notifications.reload.size).to eq(0)
    end
  end
end