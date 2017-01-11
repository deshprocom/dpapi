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

  context "验证手机验证码是否正确" do
    context "手机号格式不正确" do
      it "should return code 1100012" do
        post v10_account_verify_vcode_url,
            headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', mobile: '1371366227', vcode: '2278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100012)
      end
    end

    context "验证码不正确" do
      it "should return code 1100018" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', mobile: '13713662278', vcode: '227'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "验证通过" do
      it "should return code 0" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', mobile: '13713662278', vcode: '2278'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end

  context "验证邮箱验证码是否正确" do
    context "邮箱格式不正确" do
      it "should return code 1100011" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', email: 'ricky', vcode: 'abcd'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100011)
      end
    end

    context "验证码不正确" do
      it "should return code 1100018" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', email: 'ricky@deshpro.com', vcode: 'abc'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "验证通过" do
      it "should return code 0" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', email: 'ricky@deshpro.com', vcode: 'abcd'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end