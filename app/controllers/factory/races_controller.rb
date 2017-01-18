module Factory
  class RacesController < ApplicationController
    include DataIntegration::Races
    include Constants::Error::Common
    before_action :data_clear, only: [:create]

    def create
      method = params[:method] || ''
      unless method.to_sym.in? DataIntegration::Races.instance_methods
        return render_api_error(MISSING_PARAMETER)
      end
      send(method)
      render_api_success
    end
  end
end
