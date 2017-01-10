class DpapiConfig
  class << self
    def domain_path
      ENV['DPAPI_DOMAIN_PATH'].dup
    end
  end
end
