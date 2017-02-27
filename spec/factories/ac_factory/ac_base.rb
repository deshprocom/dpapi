module AcFactory
  class AcBase
    def self.call(ac, params)
      unless ac.to_sym.in? self.instance_methods
        Rails.logger.info "[AcFactory.ac_base] cannot find method: #{ac}"
        return false
      end

      self.new(params).send(ac)
    end

    attr_accessor :params

    def initialize(params)
      self.params = to_params(params)
    end

    def to_params(params)
      return params if params.class == ActionController::Parameters

      ActionController::Parameters.new params
    end

    def permit_user_parms
      params.permit(:email,
                    :mobile,
                    :password,
                    :user_name,
                    :nick_name).as_json
    end

    def permit_race_parms
      params.permit(:status,
                    :ticket_status,
                    :ticket_price,
                    :name,
                    :prize,
                    :location,
                    :logo).as_json
    end

    def generate_user
      user = User.find_by(email: params[:email]) if params[:email]
      return user if user

      FactoryGirl.create(:user, permit_user_parms)
    end

    def generate_race
      race = FactoryGirl.create(:race, permit_race_parms)
      FactoryGirl.create(:race_desc, race: race)
      FactoryGirl.create(:ticket_info, race: race)
      race
    end
  end
end
