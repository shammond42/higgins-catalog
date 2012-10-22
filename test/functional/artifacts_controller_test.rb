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

  context 'without an authorized user' do
    setup do
      @artifact = FactoryGirl.create(:artifact)
      FactoryGirl.create(:question, artifact: @artifact)
      FactoryGirl.create(:answered_question, artifact: @artifact)

      get :show, id: @artifact.to_param
    end

    should 'be able to ask a new question' do
      assert_select '#new_question'
    end

    should 'see answered questoins' do
      assert_select '.answered-question', count: 1
    end

    should 'not see unanswered questions' do
      assert_select '.unanswered-question', false
    end
  end

    context 'with an authorized user' do
    setup do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @artifact = FactoryGirl.create(:artifact)
      FactoryGirl.create(:question, artifact: @artifact)
      FactoryGirl.create(:answered_question, artifact: @artifact)

      get :show, id: @artifact.to_param
    end

    should 'not be able to ask a new question' do
      assert_select '#new_question', false
    end

    should 'see answered questions' do
      assert_select '.answered-question', count: 1
    end

    should 'see unanswered questions' do
      assert_select '.unanswered-question', count: 1
    end
  end
end
