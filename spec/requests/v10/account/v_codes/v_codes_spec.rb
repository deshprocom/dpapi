require 'rails_helper'

RSpec.describe "/v10/uploaders/avatar (ProfilesController)", :type => :request do
  let!(:dpapi_affiliate) { FactoryGirl.create(:affiliate_app) }
  let(:http_headers) do
    {
        ACCEPT: "application/json",
        HTTP_ACCEPT: "application/json",
        HTTP_X_DP_CLIENT_IP: "localhost",
        HTTP_X_DP_APP_KEY: "467109f4b44be6398c17f6c058dfa7ee"
    }
  end

  context "获取验证码" do
    context "options_type不正确" do
      it "should return code 1100022" do
        post v10_account_v_codes_url,
             headers: http_headers,
             params: {option_type: 'error_type', vcode_type: 'mobile', email: '13713662278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100022)
      end
    end

    context "vcode_types不正确" do
      it "should return code 1100019" do
        post v10_account_v_codes_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'error_type', email: '13713662278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100019)
      end
    end

    context "手机号格式不正确" do
      it "should return code 1100012" do
        post v10_account_v_codes_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', mobile: '12713662278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100012)
      end
    end

    context "邮箱格式不正确" do
      it "should return code 1100011" do
        post v10_account_v_codes_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', email: '12713662278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100011)
      end
    end

    context "正常发送验证码" do
      it "should return code 0" do
        post v10_account_v_codes_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', mobile: '13713662278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end