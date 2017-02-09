class AcCreator
  Dir[Rails.root.join('spec/factories/ac_factory/*.rb')].each { |f| require f }

  class << self
    include AcFactory::Us001
  end
end