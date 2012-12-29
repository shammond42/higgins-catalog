class AdminController < ApplicationController
  before_filter :authenticate_user!

  def index
    @artifact_count = Artifact.count
    @unanswered_question_count = Question.unanswered.count
    @searches = {}
    @searches[:total] = SearchLog.count
    @searches[:today] = SearchLog.since(Date.today.to_time).count
    @searches[:last_seven_days] = SearchLog.since(7.days.ago).count
    @searches[:last_30_days] = SearchLog.since(30.days.ago).count
  end
end
