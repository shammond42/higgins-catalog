class AdminController < ApplicationController
  before_action :authenticate_user!

  def index
    @artifact = Artifact.of_the_day

    @artifact_count = Artifact.count
    @last_database_import = Artifact.order('created_at desc').first.created_at
    @unanswered_question_count = Question.unanswered.count

    @searches = {}
    @searches[:total] = SearchLog.count
    @searches[:today] = SearchLog.since(Date.today.to_time).count
    @searches[:last_seven_days] = SearchLog.since(7.days.ago).count
    @searches[:last_30_days] = SearchLog.since(30.days.ago).count

    @questions = {}
    @questions[:total] = Question.count
    @questions[:unanswered] = Question.unanswered.count
    @questions[:answered] = Question.answered.count
  end

  def user_report
    @users = User.all
  end

  def search_report
    @num_terms = 25

    if(params[:num_days] == 'all')
      @num_days = params[:num_days]
      conditions = ['search_type = ?', 'keyword']
    else
      @num_days = (params[:num_days] || 30).to_i
      conditions = ['search_type = ? and created_at >= ?', 'keyword', @num_days.days.ago]
    end


    @popular_searches = SearchLog.group(:terms).order('count_all desc').where(conditions).limit(@number_terms).count
      # group: :terms,
      # order: 'count_all desc',
      # conditions: conditions,
      # limit: @num_terms)
  end
end
