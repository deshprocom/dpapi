require 'rails_helper'

RSpec.describe "/v10/account/change_account", :type => :request do
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

  context "传递过来的参数不正确" do
    it "应当返回code 1100002" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "invalid", account: "13833337890", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100002)
    end
  end

  context "传递过来的account或new_code或old_code为空" do
    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end

    it "应当返回code 1100001" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "123456", old_code: "" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100001)
    end
  end

  context "传入的邮箱或者手机号码格式不正确" do
    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "12355664433", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100012)
    end

    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "email", account: "rickyer", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(1100011)
    end
  end

  context "正确传入参数" do
    it "应当返回code 0" do
      post v10_account_user_change_account_index_url(user.user_uuid),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: { type: "mobile", account: "13833337890", new_code: "123456", old_code: "123456" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json["code"]).to eq(0)
      expect(json['data']['user_id']).to eq('uuid_123456789')
      expect(json['data']['nick_name']).to eq('Ricky')
      expect(json['data']['user_name']).to eq('Ricky')
    end
  end
end
