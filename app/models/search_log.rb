class SearchLog < ActiveRecord::Base
  before_validation :set_default_values
  validates_presence_of :terms, :search_type

  scope :since, lambda {|time| where('created_at > ?', time)}
  
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
