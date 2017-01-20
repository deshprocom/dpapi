module Factory
  class ApplicationController < ::ApplicationController
    Dir[Rails.root.join('spec/factories/data_integration/*.rb')].each { |f| require f }

    def data_clear
      return if Rails.env.production?

      DatabaseCleaner.strategy = :truncation, { except: %w(affiliates affiliate_apps) }
      DatabaseCleaner.clean
      Rails.cache.clear
      render_api_success
    end
  end
end
