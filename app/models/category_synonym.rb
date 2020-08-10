class CategorySynonym < ActiveRecord::Base
  validates_presence_of :category, :synonym
end
