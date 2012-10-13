require 'test_helper'

class ArtifactImageTest < ActiveSupport::TestCase
  should allow_mass_assignment_of(:artifact_id)
  should allow_mass_assignment_of(:path)
  should allow_mass_assignment_of(:sort_order)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should validate_presence_of(:artifact_id)
  should validate_presence_of(:path)

  should belong_to(:artifact)
end
