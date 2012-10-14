require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  tests ArtifactsController

  test 'browse artifacts' do
    5.times{FactoryGirl.create(:artifact)}
    puts Artifact.all.map(&:accession_number)

    get :index
    assert_not_nil assigns[:artifacts]
    assert_equal 5, assigns[:artifacts].size
    assert_response :success
    assert_template :index
  end
end
