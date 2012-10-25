class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  def index
    @questions = Question.unanswered.order('created_at asc').includes(:artifact)
  end

  def create
    @question = Question.create(params[:question])
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:artifact_id]))
    @artifact.questions << @question

    if request.xhr?
      render partial: 'questions/processing', locals: {question: @question}, layout: nil
    else
      flash[:success] = 'Thank you for the question. Watch your e-mail for the answer.'
      redirect_to :back
    end
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
