class ArtifactsController < ApplicationController
  def index
    @artifacts = Artifact.search(params)
  end

  def show
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:id]))
    @new_question = @artifact.questions.build
  end

  def daily
    if params[:screenshot].present?
      @artifact = Artifact.find_by_accession_number('2000.02')
      render :show
    else
      @artifact = Artifact.of_the_day
      @new_question = @artifact.questions.build
    end
  end
end
