require 'rails_helper'

RSpec.describe DpapiConfig, type: :model do
  context "获取用户头像的主机地址" do
    it "should not nil" do
      expect(DpapiConfig.domain_path).not_to eq(nil)
    end
  end
end