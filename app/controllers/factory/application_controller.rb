module Factory
  class ApplicationController < ::ApplicationController
    Dir[Rails.root.join('spec/factories/data_integration/*.rb')].each { |f| require f }

    def data_clear
      return unless Rails.env.test?

      DatabaseCleaner.strategy = :truncation, { except: %w(affiliates affiliate_apps) }
      DatabaseCleaner.clean
      Rails.cache.clear
    end
  end
end
