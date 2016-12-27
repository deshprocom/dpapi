module Serviceable
  extend ActiveSupport::Concern

  module ClassMethods
    def call(*args)
      self.new(*args).call
    end
  end
end