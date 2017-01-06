class DpapiConfig
  cattr_accessor :config
  self.config ||= YAML.load_file(Rails.root.join("config", "dpapi.yml"))[Rails.env]


  class << self
    def domain_path
      config["domain_path"].dup
    end
  end
end