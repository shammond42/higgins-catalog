class ArtifactsController < ApplicationController
  def index
    query = params[:query].present? ? params[:query] : ''
    # filter_params
    low_date = params[:low_date].present? ? params[:low_date].to_i : -10_000
    high_date = params[:high_date].present? ? params[:high_date].to_i : 10_000

    @artifacts = Artifact.search(params[:query], low_date, high_date).paginate(page: params[:page], per_page: 10)

    @search_log = SearchLog.create_from_query_string(params[:query]) if params[:query].present?
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
      @questions = @artifact.questions.not_spam.sort_by{|q| [q.answer.present? ? -1 : 1, q.created_at]}
    else
      @questions = @artifact.questions.answered
    end

    @new_question = Question.new
    @new_question.artifact = @artifact
  end

  def daily
    @artifact = Artifact.of_the_day
  end

  protected

  def filter_params
    if(params[:query] =~ DATE_RANGE_REGEX)
      params[:low_date] = $2
      params[:high_date] = $3
      params[:keyword] = params[:query].sub(DATE_RANGE_REGEX,'')
    else
      if session[:search_params]
        params[:high_date] ||= session[:search_params][:high_date]
        params[:low_date] ||= session[:search_params][:low_date]
      end
      params[:keyword] = params[:query]
    end

    params[:keyword].gsub!('keyword:','') if params[:keyword]
  end

  DATE_RANGE_REGEX = /(date_range\:)?\s*(\-?\d+)\s*\-\s*(\-?\d+)/
end
