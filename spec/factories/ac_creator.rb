class AcCreator
  Dir[Rails.root.join('spec/factories/ac_factory/*.rb')].each { |f| require f }

  def self.call(ac, params = {})
    ac.downcase!
    ac_node = "AcFactory::#{ac[0..7].classify}".safe_constantize
    if ac_node.nil?
      Rails.logger.info "[AcFactory.ac_node] cannot find class: #{ac_node}"
      return false
    end
    ac_node.call(ac, params)
  end
end