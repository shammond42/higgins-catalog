require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  RESTRICTED_PAGES = [:index, :search_report, :user_report]

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
      FactoryGirl.create(:quality_artifact)
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

    context 'viewing the search report' do
      should 'have data ready' do
        get :search_report
        assert_response :success
        assert_template :search_report

        assert_not_nil assigns[:num_terms]
        assert_not_nil assigns[:num_days]
        assert_not_nil assigns[:popular_searches]
      end

      should 'have sensible defaults' do
        get :search_report
        assert_equal 30, assigns[:num_days]
        assert_equal 25, assigns[:num_terms]
      end

      should 'filter by the number of days' do
        10.times{|i| FactoryGirl.create(:search_log, terms: 'sword', created_at: i.days.ago)}
        get :search_report, num_days: 7

        assert_equal 7, assigns[:num_days]
        assert_equal 1, assigns[:popular_searches].length
        assert_equal 7, assigns[:popular_searches]['sword']
      end
    end

    context 'viewing the user report' do
      should 'have data ready' do
        get :user_report
        assert_response :success
        assert_template :user_report

        assert_not_nil assigns[:users]
        assert_equal User.count, assigns[:users].size
      end
    end
  end
end
