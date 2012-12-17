require 'test_helper'

class SearchLogTest < ActiveSupport::TestCase
  should validate_presence_of(:terms)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should allow_mass_assignment_of(:terms)
  should allow_mass_assignment_of(:search_type)
  should allow_mass_assignment_of(:linked_search)

  context 'A new search term' do
    should 'have "keyword" as a default term' do
      search_log = SearchLog.new(terms: 'The One Ring')
      assert search_log.save!
      assert_equal 'keyword', search_log.search_type

      search_log = SearchLog.new(terms: '1500-1600', search_type: 'daterange')
      assert search_log.save
      assert_equal 'daterange', search_log.search_type
    end
  end

  context 'The SearchLog class' do
    should 'be able to create a new log from the search string when it includes a type' do
      search_log = SearchLog.create_from_query_string('accession_number:960.2')
      assert_equal 'accession_number', search_log.search_type
      assert_equal '960.2', search_log.terms
      assert search_log.valid?
    end

    should 'be able to create a new log from the search string when there is no type' do
      search_log = SearchLog.create_from_query_string('hammer')
      assert_equal 'keyword', search_log.search_type
      assert_equal 'hammer', search_log.terms
      assert search_log.valid?
    end
  end
end
