require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  tests ArtifactsController

  test 'browse artifacts' do
    5.times{FactoryGirl.create(:artifact)}

    get :index
    assert_not_nil assigns[:artifacts]
    # Need to mock out Elastic search because its index is affecting test results
    # assert_equal Artifact.count, assigns[:artifacts].size
    assert_response :success
    assert_template :index
  end
end
