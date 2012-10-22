require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  test 'ask a question' do
    artifact = FactoryGirl.create(:artifact)
    redirect_path = artifact_url(artifact)
    request.env["HTTP_REFERER"] = redirect_path

    old_question_count = Question.count

    post :create, artifact_id: artifact.to_param, question: {question: 'What is this?', nickname: 'Bilbo',
      email: 'bbaggins@fellowship.org'}

    assert_response :redirect
    assert_redirected_to redirect_path
    assert_not_nil assigns[:artifact] 
    assert_equal old_question_count + 1, Question.count
  end

  context 'an unauthenticated user' do
    should 'not be able to see restricted pages' do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_url

      put :update, id: FactoryGirl.create(:question)
      assert_response :redirect
      assert_redirected_to new_user_session_url
    end
  end
end
