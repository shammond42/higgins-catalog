class ArtifactImage < ActiveRecord::Base
  attr_accessible :artifact_id, :path, :sort_order

  validates_presence_of :artifact_id
  validates_presence_of :path

  belongs_to :artifact

end
