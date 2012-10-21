class QuestionsController < ApplicationController
  # def index
  #   @questions = Question.unanswered.order('created_at asc')
  # end

  def create
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:artifact_id]))
    @artifact.questions.create(params[:question])
    redirect_to :back
  end

  # def update
  #   @question = Question.find(params[:id])
  #   @question.update_attributes(params[:question])
  #   redirect_to :back
  # end
end
