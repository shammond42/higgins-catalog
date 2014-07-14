require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  tests ArtifactsController

  setup do
    Artifact.tire.index.delete
    load File.expand_path("../../../app/models/artifact.rb", __FILE__)
    sleep 0.1
  end

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

    get :show, id: artifact.to_param
    assert_response :success
    assert_template :show
    assert_not_nil assigns[:artifact]    
  end

  test 'record all queries' do
    @search_log_count = SearchLog.count
    get :index, {query: 'hammer'}
    assert_equal @search_log_count+1, SearchLog.count
    assert_equal 'hammer', assigns[:search_log].terms
    assert_equal 'keyword', assigns[:search_log].search_type

    get :index, {query: 'accession_number:906.2'}
    assert_equal @search_log_count+2, SearchLog.count
    assert_equal '906.2', assigns[:search_log].terms
    assert_equal 'accession_number', assigns[:search_log].search_type
  end

  test 'artifact not found' do
    assert_nil Artifact.find_by_accession_number('this_id_does_not_exist')
    get :show, id: 'this_id_does_not_exist'
    assert_response 301
    assert flash[:warning] =~ /unable to find that page/
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

    should 'not see the return to questions list button' do
      assert_select '#return-to-questions', false
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

    should 'see the return to questions list button' do
      assert_select '#return-to-questions', true
    end

    should 'see answered questions' do
      assert_select '.answered-question', count: 1
    end

    should 'see unanswered questions' do
      assert_select '.unanswered-question', count: 1
    end
  end
end
