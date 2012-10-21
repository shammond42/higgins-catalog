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

  should have_many(:artifact_images)
  
  context 'the Artifact class' do
    should 'be able to select an artifact of the day' do
      5.times {FactoryGirl.create(:artifact)}
      5.times {FactoryGirl.create(:quality_artifact)}

      Timecop.freeze(Time.local(2012, 10, 21)) do 
        assert Artifact.all.include?(Artifact.of_the_day)
        aod = Artifact.of_the_day
        assert_equal aod, Artifact.of_the_day, 'Should return the same object all day.'
        Timecop.travel(2.days.from_now) do 
          assert_not_equal aod, Artifact.of_the_day, 'Should return a different object tomorrow.'
        end
      end
    end

    should 'be able to find artifacts with quality descriptions' do
      FactoryGirl.create(:artifact, comments: nil, description: nil)
      FactoryGirl.create(:artifact, comments: nil, description: 'It is made of metal.')
      FactoryGirl.create(:artifact, comments: 'This is a great artifact.', description: nil)
      FactoryGirl.create(:artifact, comments: 'This is a great artifact', description: 'It is made of metal.')

      # quality_artifact = FactoryGirl.create(:artifact, comments: 'This is a great artifact',
      #   description: 'It is made of metal.')
      # quality_artifact.artifact_images << FactoryGirl.create(:artifact_image,
      #   artifact_id: quality_artifact.id )
      quality_artifact = FactoryGirl.create(:quality_artifact)

      assert_equal 1, Artifact.quality_entries.count
      assert_equal quality_artifact, Artifact.quality_entries.first
    end

    should 'be able to return a accession id from a query param' do
      assert_equal '1994', Artifact.from_param('1994')
      assert_equal '1994.23', Artifact.from_param('1994-23').to_param
      assert_equal '1994.23.a', Artifact.from_param('1994-23-a')
      assert_equal '1994.23.a & b', Artifact.from_param('1994.23.a & b')
    end
  end

  context 'an Artifact instance' do
    setup do
      FactoryGirl.create(:category_synonym, category: 'blade', synonym: 'edged weapon')
      FactoryGirl.create(:category_synonym, category: 'sharp thing', synonym: 'blade')
      FactoryGirl.create(:category_synonym, category: 'mace', synonym: 'blunt weapon')
      @artifact = FactoryGirl.build(:artifact, alt_name: 'blade')
    end

    should 'report its synonyms' do
      synonyms = @artifact.category_synonyms
      # assert_equal 3, synonyms.size
      assert synonyms.include?('blade')
      assert synonyms.include?('edged weapon')
      assert synonyms.include?('sharp thing')
      deny synonyms.include?('mace')
      deny synonyms.include?('blunt weapon')
    end

    should 'use its accession_number as an id param' do
      assert_equal '1994', FactoryGirl.build(:artifact, accession_number: '1994').to_param
      assert_equal '1994-23', FactoryGirl.build(:artifact, accession_number: '1994.23').to_param
      assert_equal '1994-23-a', FactoryGirl.build(:artifact, accession_number: '1994.23.a').to_param
      assert_equal '1994-23-a:b', FactoryGirl.build(:artifact, accession_number: '1994.23.a & b').to_param
    end
  end
end
