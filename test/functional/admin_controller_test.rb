require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  RESTRICTED_PAGES = [:index, :search_report]

  context 'an unauthenticated user' do
    should 'not be able to see restricted pages' do
      RESTRICTED_PAGES.each do |page|
        get page
        assert_response :redirect
        assert_redirected_to new_user_session_url
      end
    end
  end

  context 'an authenticated user' do
    setup do
      Factory.create(:quality_artifact)
      @user = FactoryGirl.create(:user)
      sign_in @user
    end

    should 'be able to see the restricted actions' do
      RESTRICTED_PAGES.each do |page|
        get :index
        assert_response :success
        assert_template :index
      end

      question = FactoryGirl.create(:question)
      redirect_path = artifact_url(question.artifact)
      request.env["HTTP_REFERER"] = redirect_path
    end

    should 'have summary data ready for the admin index view' do
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

    should 'have data ready for the search report' do
      get :search_report
      assert_response :success
      assert_template :search_report
    end
  end
end
