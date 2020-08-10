require 'test_helper'

class ArtifactTest < ActiveSupport::TestCase
  # should validate_uniqueness_of(:accession_number)
  # should validate_presence_of(:accession_number)

  # should have_many(:artifact_images)
  
  context 'the Artifact class' do
    should 'be able to select an artifact of the day' do
      10.times {FactoryGirl.create(:artifact)}
      10.times {FactoryGirl.create(:quality_artifact)}

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
  end

  context 'an Artifact instance' do
    setup do
      FactoryGirl.create(:category_synonym, category: 'blade', synonym: 'edged weapon')
      FactoryGirl.create(:category_synonym, category: 'sharp thing', synonym: 'blade')
      FactoryGirl.create(:category_synonym, category: 'mace', synonym: 'blunt weapon')

      FactoryGirl.create(:geoloc_synonym, geoloc: 'Minas Morgul', synonym: 'Mordor')
      FactoryGirl.create(:geoloc_synonym, geoloc: 'Minas Morgul', synonym: 'Middle Earth')
      FactoryGirl.create(:geoloc_synonym, geoloc: 'Hobbiton', synonym: 'Middle Earth')
      
      @artifact = FactoryGirl.build(:artifact, alt_name: 'blade', geoloc: 'Minas Morgul')
    end

    should 'report its category synonyms' do
      synonyms = @artifact.category_synonyms

      assert synonyms.include?('blade')
      assert synonyms.include?('edged weapon')
      assert synonyms.include?('sharp thing')
      deny synonyms.include?('mace')
      deny synonyms.include?('blunt weapon')
    end

    should 'report its geoloc synonyms' do
      geo_syn = @artifact.geoloc_synonyms

      assert geo_syn.include?('Minas Morgul')
      assert geo_syn.include?('Mordor')
      assert geo_syn.include?('Middle Earth')
      deny geo_syn.include?('Hobbiton')
    end

    should 'use its accession_number as an id param' do
      assert_equal '1994', FactoryGirl.build(:artifact, accession_number: '1994').to_param
      assert_equal '1994.23', FactoryGirl.build(:artifact, accession_number: '1994.23').to_param
      assert_equal '1994.23.a', FactoryGirl.build(:artifact, accession_number: '1994.23.a').to_param
      assert_equal '1994.23.a&b', FactoryGirl.build(:artifact, accession_number: '1994.23.a&b').to_param
    end

    should 'return the origin_with_date' do
      artifact = FactoryGirl.build(:artifact)
      assert_nil artifact.origin
      assert_nil artifact.prob_date
      assert_equal '', artifact.origin_with_date

      artifact.origin = 'Mordor'
      assert_equal 'Mordor', artifact.origin_with_date

      artifact.origin = nil
      artifact.prob_date = '1450 - 1500'
      assert_equal '1450 - 1500', artifact.origin_with_date

      artifact.origin = 'Mordor'
      assert_equal 'Mordor, 1450 - 1500', artifact.origin_with_date
    end

    should 'return the best field it has for artifact of the day' do
      artifact = FactoryGirl.build(:artifact, description: 'description')
      assert_equal 'description', artifact.daily_summary

      artifact.comments = 'comments'
      assert_equal 'comments', artifact.daily_summary

      artifact.old_labels = 'old labels'
      assert_equal 'old labels', artifact.daily_summary

      artifact.label_text = 'label text'
      assert_equal 'label text', artifact.daily_summary
    end
  end
end
