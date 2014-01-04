require 'test_helper'

class ArtifactImageTest < ActiveSupport::TestCase
  should_not allow_mass_assignment_of(:artifact_id)
  should_not allow_mass_assignment_of(:image)
  should allow_mass_assignment_of(:sort_order)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should validate_presence_of(:artifact_id)
  should validate_presence_of(:image)

  should belong_to(:artifact)
end
