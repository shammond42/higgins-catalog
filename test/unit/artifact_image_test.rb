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

  context 'an instance' do
    setup do
      @ai = FactoryGirl.build(:artifact_image)
    end
    should 'know the file name of its image' do
      assert_equal 'jay.jpg', @ai.filename
    end

    should 'know the base of its image file name' do
      assert_equal 'jay', @ai.filename_base
    end

    should 'be able to calculate which image name is closer to its accession number' do
      new_ai = FactoryGirl.build(:artifact_image,
        image: File.open( Rails.root + 'app/assets/images/avatar-body.png'))
      assert @ai.is_closer_to_accession_number_than?(new_ai)

      new_ai = FactoryGirl.build(:artifact_image,
        image: File.open( Rails.root + 'app/assets/images/jay.jpg')) #Same file as used in the factory
      deny @ai.is_closer_to_accession_number_than?(new_ai)
    end
  end
end
