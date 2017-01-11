require 'rails_helper'

RSpec.describe Services::Account::EmailVerifyVcodeService do
  let!(:user) { FactoryGirl.create(:user) }

  context "手机号格式错误" do
    it "should return code 1100011" do
      vcode_service = Services::Account::EmailVerifyVcodeService
      api_result = vcode_service.call('ricky', '2278')
      expect(api_result.code).to eq(1100011)
    end
  end

  context "验证码错误" do
    it "should return code 1100018" do
      vcode_service = Services::Account::EmailVerifyVcodeService
      api_result = vcode_service.call('ricky@deshpro.com', '2222')
      expect(api_result.code).to eq(1100018)
    end
  end

  context "验证通过" do
    it "should return code 0" do
      vcode_service = Services::Account::EmailVerifyVcodeService
      api_result = vcode_service.call('ricky@deshpro.com', 'abcd')
      expect(api_result.code).to eq(0)
    end
  end
end