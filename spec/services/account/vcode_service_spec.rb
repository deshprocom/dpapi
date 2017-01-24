require 'rails_helper'

RSpec.describe Services::Account::VcodeServices do
  context "如果请求没有账户id" do
    it "should return code 1100001" do
      vcode_service = Services::Account::VcodeServices
      params = {
        option_type: 'reset_pwd',
        vcode_type: 'email'
      }
      api_result = vcode_service.call(params)
      expect(api_result.code).to eq(1100001)
    end
  end

  context "如果发送邮箱验证码，但是邮箱格式不正确" do
    it "should return code 1100011" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'reset_pwd',
          vcode_type: 'email',
          email: 'ricky@'
      }
      api_result = vcode_service.call(params)
      expect(api_result.code).to eq(1100011)
    end
  end

  context "发送邮箱验证码,正常发送" do
    it "should return code 0" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'reset_pwd',
          vcode_type: 'email',
          email: 'ricky@deshpro.com'
      }
      api_result = vcode_service.call(params)
      expect(api_result.code).to eq(0)
    end
  end

  context "发送手机验证码,手机格式不正确" do
    it "should return code 1100012" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'reset_pwd',
          vcode_type: 'mobile',
          mobile: '12345556667'
      }
      api_result = vcode_service.call(params)
      expect(api_result.code).to eq(1100012)
    end
  end

  context "发送手机验证码,正常发送" do
    it "should return code 0" do
      vcode_service = Services::Account::VcodeServices
      params = {
          option_type: 'reset_pwd',
          vcode_type: 'mobile',
          mobile: '13713662278'
      }
      api_result = vcode_service.call(params)
      expect(api_result.code).to eq(0)
    end
  end
end