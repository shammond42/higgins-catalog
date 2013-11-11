require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  should allow_mass_assignment_of(:answer)
  should allow_mass_assignment_of(:question)
  should allow_mass_assignment_of(:nickname)
  should allow_mass_assignment_of(:email)
  should allow_mass_assignment_of(:is_spam)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should belong_to(:artifact)
end
