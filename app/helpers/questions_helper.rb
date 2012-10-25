module QuestionsHelper
  def delete_question_link(question)
    link_to 'Delete Question', question_path(question), method: :delete,
        confirm: 'Are you sure? This action can not be undone.',
        class: 'btn btn-danger btn-mini'
  end

  def question_class(question)
    question.answer.present? ? 'answered-question' : 'unanswered-question'
  end

  def thank_you_title(question)
    greeting = question.nickname.titlecase+', ' if question.nickname.present?
    "#{greeting}Thank You for Your Question"
  end
end
