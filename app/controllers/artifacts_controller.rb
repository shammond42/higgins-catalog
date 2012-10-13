class ArtifactsController < ApplicationController
  def show
    puts params[:id]
    @artifact = Artifact.find_by_accession_number(Artifact.from_param(params[:id]))
  end
end
