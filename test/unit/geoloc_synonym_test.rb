require 'test_helper'

class GeolocSynonymTest < ActiveSupport::TestCase
  should_not allow_mass_assignment_of(:id)

  should allow_mass_assignment_of(:geoloc)
  should allow_mass_assignment_of(:synonym)

  should validate_presence_of(:geoloc)
  should validate_presence_of(:synonym)
end
