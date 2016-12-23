module AffiliateAppCacheable
  extend ActiveSupport::Concern

  included do
    class << self
      @cache_loaded = false
    end
  end

  module ClassMethods
    def load_to_cache(reload = false)
      puts "loading all apps to cache"
      if !@cache_loaded or reload
        @cached_app_keys = []
        self.all.each do |app|
          self.find_by_app_key(app.app_key)
          @cached_app_keys.push app.app_key
          self.cache_store.write app_cache_key(app.app_key), 1
        end
        @cache_loaded = true
      end
    end

    def cache_loaded?
      @cache_loaded = false if @cache_loaded.nil?
      @cache_loaded
    end

    def from_cache(app_key)
      if self.cache_store.exist?(app_cache_key(app_key))
        self.find_by_app_key(app_key)
      end
    end

    private
    def app_cache_key(app_key)
      "dpapi:v10:affiliate_app:#{app_key}"
    end
  end
end