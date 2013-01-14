class QuestionMailer < ActionMailer::Base
  add_template_helper(QuestionsHelper)
  default from: "higgins@lostpapyr.us"

  def question_notification(question)
    addresses = User.question_responders.map(&:email)
    @question = question
    @artifact = question.artifact
    mail(to: addresses, subject: '[Online Catalog] New Question')
  end

  def answer_notification(question)
    return unless question.email.present?

    address = question.email
    @question = question
    @artifact = question.artifact
    mail(to: address, subject: '[Higgins Online Catalog] Your question has been answered.')
  end
end
