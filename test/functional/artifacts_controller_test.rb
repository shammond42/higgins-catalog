require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  tests ArtifactsController

  test 'browse artifacts' do
    5.times{FactoryGirl.create(:artifact)}

    get :index
    assert_not_nil assigns[:artifacts]
    # TODO: Need to mock out Elastic search because its index is affecting test results
    # assert_equal Artifact.count, assigns[:artifacts].size
    assert_response :success
    assert_template :index
  end

  test 'look at a specific artifact' do
    artifact = FactoryGirl.create(:artifact)

    get :show, :id => artifact.to_param
    assert_response :success
    assert_template :show
    assert_not_nil assigns[:artifact]    
  end

  test 'daily artifiact' do
    artifact = FactoryGirl.create(:quality_artifact)

    get :daily
    assert_response :success
    assert_template :daily
    assert_equal artifact, assigns(:artifact)
  end
end
