require 'test_helper'

class CategoryXrefTest < ActiveSupport::TestCase
  should_not allow_mass_assignment_of(:id)

  should allow_mass_assignment_of(:category)
  should allow_mass_assignment_of(:xref)
  should allow_mass_assignment_of(:note)

  should validate_presence_of(:category)
  should validate_presence_of(:xref)
end
