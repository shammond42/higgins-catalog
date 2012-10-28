require 'test_helper'

class QuestionsHelperTest < ActionView::TestCase
  test 'question_class' do
    question = FactoryGirl.build(:question, answer: nil)
    assert_equal 'unanswered-question', question_class(question)

    question.answer = 'An answert'
    assert_equal 'answered-question', question_class(question)
  end

  test 'thank_you_title' do
    question = FactoryGirl.build(:question, nickname: nil)
    assert_equal 'Thank You for Your Question', thank_you_title(question)

    question.nickname = 'darklord'
    assert_equal 'Darklord, Thank You for Your Question', thank_you_title(question)
  end

  test 'question_byline without a signed in user' do
    Timecop.freeze(2012, 05, 22) do
      self.stubs(:user_signed_in?).returns(false)
      question = FactoryGirl.build(:question, nickname: nil, email: nil, created_at: Time.now)
      assert_equal 'Asked by Anonymous on May 22, 2012', question_byline(question)

      question.email = 'bbaggins@shire.net'
      assert_equal 'Asked by Anonymous on May 22, 2012', question_byline(question)

      question.nickname = 'bbaggins'
      assert_equal 'Asked by bbaggins on May 22, 2012', question_byline(question)
    end
  end

  test 'question_byline with a signed in user' do
    Timecop.freeze(2012, 05, 22) do
      self.stubs(:user_signed_in?).returns(true)
      question = FactoryGirl.build(:question, nickname: nil, email: nil, created_at: Time.now)
      assert_equal 'Asked by Anonymous (email not given) on May 22, 2012', question_byline(question)

      question = FactoryGirl.build(:question, nickname: nil, email: 'bbaggins@shire.net', created_at: Time.now)
      assert_equal 'Asked by Anonymous (<a href="mailto://bbaggins@shire.net">bbaggins@shire.net</a>) on May 22, 2012', question_byline(question)

      question = FactoryGirl.build(:question, nickname: 'bbaggins', email: 'bbaggins@shire.net', created_at: Time.now)
      assert_equal 'Asked by bbaggins (<a href="mailto://bbaggins@shire.net">bbaggins@shire.net</a>) on May 22, 2012', question_byline(question)

      question = FactoryGirl.build(:question, nickname: 'bbaggins', email: nil, created_at: Time.now)
      assert_equal 'Asked by bbaggins (email not given) on May 22, 2012', question_byline(question)

      # Test escaping
      question = FactoryGirl.build(:question, nickname: '<b>bbaggins</b>', email: nil, created_at: Time.now)
      assert_equal 'Asked by &lt;b&gt;bbaggins&lt;/b&gt; (email not given) on May 22, 2012', question_byline(question)    

      question = FactoryGirl.build(:question, nickname: 'bbaggins', email: 'shammond@<script>alert("hello");</script>', created_at: Time.now)
      assert_equal 'Asked by bbaggins (<a href="mailto://shammond@&lt;script&gt;alert(&quot;hello&quot;);&lt;/script&gt;">shammond@&lt;script&gt;alert(&quot;hello&quot;);&lt;/script&gt;</a>) on May 22, 2012', question_byline(question)      
    end
  end
end
