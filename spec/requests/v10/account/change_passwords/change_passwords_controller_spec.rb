require 'rails_helper'

RSpec.describe "/v10/account/users/:user_id/change_password", :type => :request do
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

  context "未登录情况下访问" do
    it "应当返回 code: 805" do
      params = {
        type:        'pwd',
        new_pwd:     'geek',
        old_pwd:        '1'
      }
      post v10_account_user_change_password_url(user.user_uuid),
           headers: http_headers,
           params: params
      expect(response).to have_http_status(805)
    end
  end

  context "传入的access_token不匹配当前要修改的用户身份" do
    it "应当返回 code: 806" do
      params = {
        type:        'pwd',
        new_pwd:     'geek',
        old_pwd:        '1'
      }
      post v10_account_user_change_password_url('123'),
           headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
           params: params
      expect(response).to have_http_status(806)
    end
  end

  context "通过旧密码的方式修改密码" do
    context "传入的参数为空" do
      it "应当返回 code: 1100001" do
        params = {
          type:       'pwd',
          new_pwd:     '',
          old_pwd:     ''
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "传入的老密码和原来的不一致" do
      it "应当返回 code: 1100017" do
        params = {
          type:        'pwd',
          new_pwd:     'hello133',
          old_pwd:     'test12'
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100017)
      end
    end

    context "更改成功" do
      it "应当返回 code: 0" do
        params = {
          type:        'pwd',
          new_pwd:     'hello123',
          old_pwd:     'test123'
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end

  context "通过验证码的方式修改" do
    context "如果缺少传入的参数" do
      it "should return code 1100001" do
        params = {
          type:        'vcode',
          new_pwd:     'hello123',
          mobile:     '13713662278',
          vcode:      ''
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100001)
      end
    end

    context "如果验证码不正确" do
      it "should return code 1100018" do
        params = {
          type:        'vcode',
          new_pwd:     'hello123',
          mobile:     '13713662278',
          vcode:      '2222'
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "成功修改" do
      it "should return code 0" do
        params = {
          type:        'vcode',
          new_pwd:     'hello123',
          mobile:     '13713662278',
          vcode:      '2278'
        }
        post v10_account_user_change_password_url(user.user_uuid),
             headers: http_headers.merge({HTTP_X_DP_ACCESS_TOKEN: access_token}),
             params: params
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end