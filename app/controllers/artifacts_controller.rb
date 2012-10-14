class ArtifactsController < ApplicationController
  def index
    @artifacts = Artifact.search(params)
  end

  def show
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:id]))
  end
end
