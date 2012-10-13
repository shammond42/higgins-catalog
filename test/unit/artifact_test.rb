require 'test_helper'

class ArtifactTest < ActiveSupport::TestCase
  should validate_uniqueness_of(:accession_number)
  
  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should allow_mass_assignment_of(:accession_number)
  should allow_mass_assignment_of(:std_term)
  should allow_mass_assignment_of(:alt_name)
  should allow_mass_assignment_of(:prob_date)
  should allow_mass_assignment_of(:min_date)
  should allow_mass_assignment_of(:max_date)
  should allow_mass_assignment_of(:artist)
  should allow_mass_assignment_of(:school_period)
  should allow_mass_assignment_of(:geoloc)
  should allow_mass_assignment_of(:origin)
  should allow_mass_assignment_of(:materials)
  should allow_mass_assignment_of(:measure)
  should allow_mass_assignment_of(:weight)
  should allow_mass_assignment_of(:comments)
  should allow_mass_assignment_of(:bibliography)
  should allow_mass_assignment_of(:published_refs)
  should allow_mass_assignment_of(:label_text)
  should allow_mass_assignment_of(:old_labels)
  should allow_mass_assignment_of(:exhibit_history)
  should allow_mass_assignment_of(:description)
  should allow_mass_assignment_of(:marks)
  should allow_mass_assignment_of(:public_loc)
  should allow_mass_assignment_of(:status)
end
