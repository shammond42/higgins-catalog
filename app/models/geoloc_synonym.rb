class GeolocSynonym < ActiveRecord::Base
  attr_accessible :location, :synonym

  validates_presence_of :location, :synonym
end
