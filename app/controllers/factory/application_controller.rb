module Factory
  class ApplicationController < ::ApplicationController
    include Constants::Error::Common
    before_action :data_clear, if: :clear?

    def data_clear
      return if Rails.env.production?

      DatabaseCleaner.strategy = :truncation, { except: %w(affiliates affiliate_apps) }
      DatabaseCleaner.clean
      Rails.cache.clear
    end

    def create
      ac = params.delete(:ac) || ''
      unless ac.to_sym.in? AcCreator.singleton_methods
        return render_api_error(MISSING_PARAMETER)
      end
      AcCreator.send(ac, params)
      render_api_success
    end

    def clear?
      params.delete(:clear) == 'true'
    end
  end
end
