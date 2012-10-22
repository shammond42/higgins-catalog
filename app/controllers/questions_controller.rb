class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  def index
    @questions = Question.unanswered.order('created_at asc').includes(:artifact)
  end

  def create
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:artifact_id]))
    @artifact.questions.create(params[:question])
    redirect_to :back
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes(params[:question])
    redirect_to :back
  end

  def destroy
    Question.destroy(params[:id])
    redirect_to questions_path
  end
end
