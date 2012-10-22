module QuestionsHelper

  def delete_question_link(question)
    link_to 'Delete Question', question_path(question), method: :delete,
        confirm: 'Are you sure? This action can not be undone.',
        class: 'btn btn-danger btn-mini'
  end
end
