require 'test_helper'

class QuestionsControllerTest < ActionController::TestCase
  context 'a public user' do
    setup do
      @artifact = FactoryGirl.create(:artifact)
      @user = FactoryGirl.create(:user, receives_question_notifications: true)
      
      @redirect_path = artifact_url(@artifact)
      request.env["HTTP_REFERER"] = @redirect_path

      @old_question_count = Question.count
    end

    should 'be able to ask a question' do
      post :create, params: { artifact_id: @artifact.to_param, question: {question: 'What is this?', nickname: 'Bilbo',
        email: 'bbaggins@fellowship.org'} }

      assert_response :redirect
      assert_redirected_to @redirect_path
      assert_not_nil assigns[:artifact] 
      assert_equal @old_question_count + 1, Question.count
    end

    context 'after asking the questin' do
      should 'have an e-mail sent when it is not spammy' do
        Object.stubs(:spam?).returns(false)

        # assert_emails 1 do # TODO Enable this in Rails 4
          post :create, params: { artifact_id: @artifact.to_param, question: {question: 'What is this?', nickname: 'Bilbo',
            email: 'bbaggins@fellowship.org'} }
          assert_response :redirect

          question_email = ActionMailer::Base.deliveries.last
          assert_equal @user.email, question_email.to[0]
          assert_match(/What is this/, question_email.body.to_s)
        # end
      end

      should 'not have an e-mail sent when it is spammy' do
        Question.any_instance.stubs(:spam?).returns(true)
        ActionMailer::Base.deliveries = []

        # assert_no_emails do #TODO Enable this in Rails 4
          post :create, params: { artifact_id: @artifact.to_param, question: {question: 'This is spam', nickname: 'Bilbo',
            email: 'bbaggins@fellowship.org'} }
          assert_response :redirect
          assert_nil ActionMailer::Base.deliveries.last
        # end
      end
    end
  end

  context 'as an admin' do
     setup do
      @user = FactoryGirl.create(:user)
      sign_in @user

      @artifact = FactoryGirl.create(:artifact)
    end

    context 'without unanswered questions' do
      setup do
        3.times{FactoryGirl.create(:answered_question, artifact: @artifact)}
      end

      should 'see a message instead of questions to answer' do
        get :index
        assert_response :success
        assert_template :index

        assert_equal 0, assigns(:questions).size
        assert_select 'h3', /[Nn]o questions/
      end
    end
    
    context 'with unanswered questions' do
      setup do
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

        put :update, params: { id: question, question: {answer: 'No'} }
        assert_response :redirect
        assert_not_nil assigns(:question)
        assert_equal question.id, assigns(:question).id
        assert_equal 'No', assigns(:question).answer
      end

      should 'be able to delete a question' do
        question = @artifact.questions.unanswered.first
        old_question_count = @artifact.questions.count

        delete :destroy, params: {id: question}
        assert_response :redirect
        assert_redirected_to questions_path
        assert_equal old_question_count-1, @artifact.questions.count
        deny @artifact.questions.include?(question)
      end

      should 'be able mark a question as spam' do
        question = @artifact.questions.unanswered.first
        old_spam_count = @artifact.questions.spam.count
        old_ham_count = @artifact.questions.not_spam.count

        post :mark_spam, params: {id: question}
        assert_response :redirect
        assert_redirected_to questions_path
        assert_equal old_spam_count+1, @artifact.questions.spam.count
        assert_equal old_ham_count-1, @artifact.questions.not_spam.count
      end

      should 'be able to mark a spam question as ham' do
        question = @artifact.questions.unanswered.first
        question.update_attribute(:is_spam, true)
        old_spam_count = @artifact.questions.spam.count
        old_ham_count = @artifact.questions.not_spam.count   


        post :mark_ham, params: {id: question}
        assert_response :redirect
        assert_redirected_to questions_path
        assert_equal old_spam_count-1, @artifact.questions.spam.count
        assert_equal old_ham_count+1, @artifact.questions.not_spam.count   
      end
    end
  end

  context 'an unauthenticated user' do
    should 'not be able to see restricted pages' do
      get :index
      assert_response :redirect
      assert_redirected_to new_user_session_url

      put :update, params: { id: FactoryGirl.create(:question) }
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
      put :update, params: { id: question, question: {answer: 'Test answer.'} }
      assert_response :redirect
      assert_redirected_to redirect_path
    end
  end
end
