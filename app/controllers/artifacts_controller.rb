class ArtifactsController < ApplicationController
  def index
    @artifacts = Artifact.search(params)
    @search_log = SearchLog.create_from_query_string(params[:query]) if params[:query]
    session[:search_params] = {
      query: params[:query],
      page: params[:page],
      high_date: params[:high_date],
      low_date: params[:low_date]}
  end

  def show
    @artifact = Artifact.includes(:questions, :artifact_images).find_by_accession_number(params[:id])

    if @artifact.nil?
      not_found
      return
    end

    if user_signed_in?
      @questions = @artifact.questions.sort_by{|q| [q.answer.present? ? -1 : 1, q.created_at]}
    else
      @questions = @artifact.questions.answered
    end

    @new_question = Question.new
    @new_question.artifact = @artifact
  end

  def daily
    @artifact = Artifact.of_the_day
  end
end
