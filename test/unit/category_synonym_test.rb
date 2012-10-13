require 'test_helper'

class CategorySynonymTest < ActiveSupport::TestCase
  should_not allow_mass_assignment_of(:id)

  should allow_mass_assignment_of(:category)
  should allow_mass_assignment_of(:synonym)
  should allow_mass_assignment_of(:note)

  should validate_presence_of(:category)
  should validate_presence_of(:synonym)
end
