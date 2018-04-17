module Geo
  class Location
    def self.nearby(latitude, longtitude, options = {})
      if options[:geo_type] == 'google'
        location = "#{latitude},#{longtitude}"
        ::Geo::MyLocation::Google.search(options.merge(location: location))
      else
        location = "#{longtitude},#{latitude}"
        ::Geo::MyLocation::Amap.search(options.merge(location: location))
      end
    end
  end
end
