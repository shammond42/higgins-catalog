class QuestionsController < ApplicationController
  before_filter :authenticate_user!, except: [:create]
  
  def index
    @questions = Question.unanswered.not_spam.order('created_at asc').includes(:artifact)
    @spam_questions = Question.unanswered.spam.order('created_at asc').includes(:artifact)
  end

  def create
    @artifact = Artifact.find_by_accession_number(params[:artifact_id])

    @question = @artifact.questions.build(params[:question])
    @question.is_spam = @question.spam? # Check Akismet for spam
    @question.save!

    
    QuestionMailer.question_notification(@question).deliver unless @question.is_spam?
    if request.xhr?
      render partial: 'questions/processing', locals: {question: @question}, layout: nil
    else
      flash[:success] = 'Thank you for the question. Watch your e-mail for the answer.'
      redirect_to :back
    end
  end

  def edit
    @question = Question.find(params[:id])

    if request.xhr?
      render partial: 'answer_form', locals: {question: @question}
    end
  end

  def update
    @question = Question.find(params[:id])
    @question.update_attributes(params[:question])

    QuestionMailer.answer_notification(@question).deliver if @question.email.present?

    if request.xhr?
      render partial: 'questions/question', locals: {question: @question}, layout: nil
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

  def mark_spam
    question = Question.find(params[:id])
    question.update_attribute(:is_spam, true)
    question.spam!

    if request.xhr?
      render partial: 'question_admin', locals: {question: question}
    else
      redirect_to questions_path
    end
  end

  def mark_ham
    question = Question.find(params[:id])
    question.update_attribute(:is_spam, false)
    question.ham!

    if request.xhr?
      render partial: 'question_admin', locals: {question: question}
    else
      redirect_to questions_path
    end
  end
end
