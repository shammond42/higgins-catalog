class ArtifactsController < ApplicationController
  def index
    @artifacts = Artifact.search(params)
  end

  def show
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:id]))
    @new_question = @artifact.questions.build
  end

  def daily
    @artifact = Artifact.of_the_day
    @new_question = @artifact.questions.build
  end
end
