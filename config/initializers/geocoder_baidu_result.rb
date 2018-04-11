module Geocoder::Result
  class Baidu < Base
    def town
      address_components[:town].to_s
    end

    def direction
      address_components[:direction].to_s
    end

    def business
      @data[:business]
    end
  end
end