class SearchLog < ActiveRecord::Base
  attr_accessible :linked_search, :terms, :search_type
  before_validation :set_default_values
  validates_presence_of :terms, :search_type


  def set_default_values
    self.search_type ||= 'keyword'
  end

  def self.create_from_query_string(query)
    search_log = SearchLog.new

    if query.match(':')
      search_log.search_type, search_log.terms = query.strip.split(':')
    else
      search_log.terms = query.strip
    end

    search_log.save!
    search_log
  end
end
