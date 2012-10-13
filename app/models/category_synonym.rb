class CategorySynonym < ActiveRecord::Base
  attr_accessible :category, :synonym, :note

  validates_presence_of :category, :synonym
end
