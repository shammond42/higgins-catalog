require 'carrierwave/orm/activerecord'

class ArtifactImage < ActiveRecord::Base
  attr_accessible :path, :sort_order
  mount_uploader :image, ImageUploader

  validates_presence_of :artifact_id
  validates_presence_of :image
  # validates_presence_of :path

  belongs_to :artifact

  delegate :url, :path, to: :image
end
