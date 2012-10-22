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

  context 'an admin' do
    setup do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @artifact = FactoryGirl.create(:artifact)
      5.times{FactoryGirl.create(:question, artifact: @artifact)}
      3.times{FactoryGirl.create(:answered_question, artifact: @artifact)}
    end

    should 'be able to view the list of unanswered questions' do
      get :index
      assert_response :success
      assert_equal 5, assigns(:questions).size
      assigns(:questions).each do |question|
        assert_nil question.answer, 'should only have unanswered questions.'
      end
    end

    should 'be able to answer a question' do
      question = @artifact.questions.unanswered.first
      redirect_path = artifact_url(question.artifact)
      request.env["HTTP_REFERER"] = redirect_path

      put :update, id: question, question: {answer: 'No'}
      assert_response :redirect
      assert_not_nil assigns(:question)
      assert_equal question.id, assigns(:question).id
      assert_equal 'No', assigns(:question).answer
    end

    should 'be able to delete a question' do
      question = @artifact.questions.unanswered.first
      old_question_count = @artifact.questions.count

      delete :destroy, id: question
      assert_response :redirect
      assert_redirected_to questions_path
      assert_equal old_question_count-1, @artifact.questions.count
      deny @artifact.questions.include?(question)
    end
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

  context 'an authenticated user' do
    setup do
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    should 'be able to see the restricted actions' do
      get :index
      assert_response :success
      assert_template :index

      question = FactoryGirl.create(:question)
      redirect_path = artifact_url(question.artifact)
      request.env["HTTP_REFERER"] = redirect_path
      put :update, id: question
      assert_response :redirect
      assert_redirected_to redirect_path
    end
  end
end
