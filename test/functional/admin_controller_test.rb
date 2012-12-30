require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  context 'an unauthenticated user' do
    should 'not be able to see restricted pages' do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_url
    end
  end

  context 'an authenticated user' do
    setup do
      Factory.create(:quality_artifact)
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
    end

    should 'have summary data ready for the views' do
      get :index
      assert_response :success

      assert assigns[:artifact]
      assert assigns[:artifact_count]
      assert assigns[:last_database_import]
      assert assigns[:unanswered_question_count]
      assert assigns[:searches]
      assert_not_nil assigns[:searches][:total]
      assert_not_nil assigns[:searches][:today]
      assert_not_nil assigns[:searches][:last_seven_days]
      assert_not_nil assigns[:searches][:last_30_days]
    end
  end
end
