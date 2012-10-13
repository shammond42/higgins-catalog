class CategorySynonym < ActiveRecord::Base
  attr_accessible :category, :xref, :note

  validates_presence_of :category, :xref
end
