require 'carrierwave/orm/activerecord'

class ArtifactImage < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  validates_presence_of :artifact_id
  validates_presence_of :image
  # validates_presence_of :path

  belongs_to :artifact

  delegate :url, :path, to: :image

  def filename
    File.basename(image.path)
  end

  def filename_base
    filename.sub(/\.jpg$/,'')
  end

  def is_closer_to_accession_number_than?(artifact_image)
    new_distance = RubyFish::Levenshtein.distance(
      artifact.accession_number, artifact_image.filename_base)
    old_distance = RubyFish::Levenshtein.distance(
      artifact.accession_number, self.filename_base)

    old_distance < new_distance
  end
end
