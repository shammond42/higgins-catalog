class GeolocSynonym < ActiveRecord::Base
  validates_presence_of :geoloc, :synonym
end
