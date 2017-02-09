module AcFactory
  module Us001
    def ac_us001_05(params = {})
      FactoryGirl.create(:user, params.permit(:email).as_json)
    end
  end
end
