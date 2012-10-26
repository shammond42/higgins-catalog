class GeolocSynonym < ActiveRecord::Base
  attr_accessible :geoloc, :synonym

  validates_presence_of :geoloc, :synonym
end
