require 'test_helper'

class ArtifactsHelperTest < ActionView::TestCase
  include ArtifactsHelper

  context 'format_artifact_name' do
    setup do
      @artifact = FactoryGirl.build(:artifact)
    end

    should 'correctly format the name' do
      @artifact.std_term = 'A sword'
      assert_equal 'A sword', format_artifact_name(@artifact)

      @artifact.std_term = 'A Sword'
      assert_equal 'A Sword', format_artifact_name(@artifact)

      @artifact.std_term = 'a Sword'
      assert_equal 'a Sword', format_artifact_name(@artifact)
      @artifact.std_term = 'A "sword"'
      assert_equal 'A &#8220;sword&#8221;', format_artifact_name(@artifact)

      @artifact.std_term = 'A-sword'
      assert_equal 'A-sword', format_artifact_name(@artifact)
    end
  end
end
