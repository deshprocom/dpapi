require 'rails_helper'

RSpec.describe Services::Account::VerifyVcodeService do
  let!(:user) { FactoryGirl.create(:user) }

  context "手机号格式错误" do
    it "should return code 1100012" do
      vcode_service = Services::Account::VerifyVcodeService
      api_result = vcode_service.call('1371366227', '2278')
      expect(api_result.code).to eq(1100012)
    end
  end

  context "验证码错误" do
    it "should return code 1100018" do
      vcode_service = Services::Account::VerifyVcodeService
      api_result = vcode_service.call('13713662278', '2222')
      expect(api_result.code).to eq(1100018)
    end
  end

  context "验证通过" do
    it "should return code 0" do
      vcode_service = Services::Account::VerifyVcodeService
      api_result = vcode_service.call('13713662278', '2278')
      expect(api_result.code).to eq(0)
    end
  end
end