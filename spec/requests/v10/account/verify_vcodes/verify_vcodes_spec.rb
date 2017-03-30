require 'rails_helper'

RSpec.describe "/v10/account/VerifyVcodesController", :type => :request do
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

  context "验证手机验证码是否正确" do
    let!(:v_code) {VCode.generate_mobile_vcode('register', '18018001880')}
    context "验证码不正确" do
      it "should return code 1100018" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', account: '18018001880', vcode: '227'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "验证通过" do
      it "should return code 0" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'mobile', account: '18018001880', vcode: v_code}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end

  context "验证邮箱验证码是否正确" do
    let!(:v_code) {VCode.generate_email_vcode('register', 'ricky@deshpro.com')}
    context "验证码不正确" do
      it "should return code 1100018" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', account: 'ricky@deshpro.com', vcode: '1234'}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(1100018)
      end
    end

    context "验证通过" do
      it "should return code 0" do
        post v10_account_verify_vcode_url,
             headers: http_headers,
             params: {option_type: 'register', vcode_type: 'email', account: 'ricky@deshpro.com', vcode: v_code}
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json["code"]).to eq(0)
      end
    end
  end
end