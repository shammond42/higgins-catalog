class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]

  def index
    @questions = Question.unanswered.order('created_at asc').includes(:artifact)
  end

  def create
    @question = Question.create(params[:question])
    @artifact = Artifact.find_by_accession_number(params[:artifact_id])
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

    if request.xhr?
      render text: @question.answer
    else
      flash[:success] = 'The question has been answered.'
      redirect_to :back
    end
  end

  def destroy
    Question.destroy(params[:id])

    if request.xhr?
      render nothing: true
    else
      redirect_to questions_path
    end
  end
end
