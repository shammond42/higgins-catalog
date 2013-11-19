module QuestionsHelper
  def delete_question_link(question)
    link_to 'Delete Question', question_path(question), method: :delete,
      class: 'btn btn-danger btn-mini btn-question-delete'
  end

  def mark_spam_link(question)
    link_to 'Mark as Spam', mark_spam_question_path(question), method: :post,
      class: 'btn btn-warning btn-mini btn-question-mark-spam'
  end

  def mark_ham_link(question)
    link_to 'Mark as Ham', mark_ham_question_path(question), method: :post,
      class: 'btn btn-success btn-mini btn-question-mark-ham'
  end

  def question_artifact_link(question)
    link_to 'Go To Artifact', artifact_path(question.artifact), class: 'btn btn-inverse btn-mini'
  end

  def edit_answer_link(question)
    link_to 'Edit Answer', edit_question_path(question),
        class: 'btn btn-inverse btn-mini btn-answer-edit'
  end

  def question_class(question)
    question.answer.present? ? 'answered-question' : 'unanswered-question'
  end

  def spam_class(question)
    question.is_spam? ? 'spam' : 'ham'
  end

  def thank_you_title(question)
    greeting = question.nickname.titlecase+', ' if question.nickname.present?
    "#{greeting}Thank You for Your Question"
  end

  def question_byline(question)
    who = question.nickname.present? ? h(question.nickname) : "Anonymous"

    # respond_to is for ActionMailer which doesn't
    if self.respond_to?(:user_signed_in?) && user_signed_in?
      who << " (#{question.email.present? ? link_to(question.email, "mailto://#{question.email}") : "email not given"})".html_safe
    end

    "Asked by #{who} on #{question.created_at.stamp('June 1, 2012')}".html_safe
  end
end
