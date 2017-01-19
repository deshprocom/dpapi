module Factory
  class RacesController < ApplicationController
    include DataIntegration::Races
    include Constants::Error::Common

    def create
      method = params[:method] || ''
      unless method.to_sym.in? DataIntegration::Races.instance_methods
        return render_api_error(MISSING_PARAMETER)
      end
      send(method)
      render_api_success
    end

    def init_followed_or_ordered_races
      user = User.by_uuid(params[:uuid])
      if user.nil?
        user = FactoryGirl.create(:user)
      end
      super(user)
    end
  end
end
