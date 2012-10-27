module QuestionsHelper
  def delete_question_link(question)
    link_to 'Delete Question', question_path(question),
        class: 'btn btn-danger btn-mini btn-question-delete'
  end

  def question_class(question)
    question.answer.present? ? 'answered-question' : 'unanswered-question'
  end

  def thank_you_title(question)
    greeting = question.nickname.titlecase+', ' if question.nickname.present?
    "#{greeting}Thank You for Your Question"
  end

  def question_byline(question)
    who = question.nickname.present? ? question.nickname : "Anonymous"
    if user_signed_in?
      who << " (#{question.email.present? ? question.email : "email not given"})"
    end

    "Asked by #{who} on #{question.created_at.stamp('June 1, 2012')}"
  end
end
