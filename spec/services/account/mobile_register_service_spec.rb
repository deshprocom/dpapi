require 'rails_helper'

RSpec.describe Services::Account::MobileRegisterService do
  let!(:user) { FactoryGirl.create(:user) }

  context "手机号格式不正确" do
    it "should return code 1100012" do
      mobile_register_service = Services::Account::MobileRegisterService
      api_result = mobile_register_service.call('1234567890', '7890')
      expect(api_result.code).to eq(1100012)
    end
  end

  context "验证码不正确" do
    it "should return code 1100018" do
      mobile_register_service = Services::Account::MobileRegisterService
      api_result = mobile_register_service.call('13876544567', '7890')
      expect(api_result.code).to eq(1100018)
    end
  end

  context "手机号是否存在" do
    let(:v_code) {VCode.generate_mobile_vcode('register', '18018001880')}
    it "should return code 1100013" do
      mobile_register_service = Services::Account::MobileRegisterService
      api_result = mobile_register_service.call('18018001880', v_code)
      expect(api_result.code).to eq(1100013)
    end
  end

  context "密码不是md5" do
    let(:v_code) {VCode.generate_mobile_vcode('register', '13967678989')}
    it "should return code 1100015" do
      mobile_register_service = Services::Account::MobileRegisterService
      api_result = mobile_register_service.call('13967678989', v_code, 'sdfsdf')
      expect(api_result.code).to eq(1100015)
    end
  end

  context "正常注册" do
    let(:v_code) {VCode.generate_mobile_vcode('register', '13967678989')}
    it "should return code 0" do
      mobile_register_service = Services::Account::MobileRegisterService
      api_result = mobile_register_service.call('13967678989', v_code, 'cc03e747a6afbbcbf8be7668acfebee5')
      expect(api_result.code).to eq(0)
    end
  end
end