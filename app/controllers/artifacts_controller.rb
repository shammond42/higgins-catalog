class ArtifactsController < ApplicationController
  def index
    filter_params

    @artifacts = Artifact.search(params)
    @search_log = SearchLog.create_from_query_string(params[:keyword]) if params[:keyword].present?
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
