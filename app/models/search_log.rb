class SearchLog < ActiveRecord::Base
  attr_accessible :linked_search, :terms, :type
  before_validation :set_default_values
  validates_presence_of :terms, :type


  def set_default_values
    self.type ||= 'keyword'
  end
end
