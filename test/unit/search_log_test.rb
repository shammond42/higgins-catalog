require 'test_helper'

class SearchLogTest < ActiveSupport::TestCase
  should validate_presence_of(:terms)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should allow_mass_assignment_of(:terms)
  should allow_mass_assignment_of(:type)
  should allow_mass_assignment_of(:linked_search)

  context 'A new search term' do
    should 'have "keyword" as a default term' do
      search_log = SearchLog.new(terms: 'The One Ring')
      assert search_log.save!
      assert_equal 'keyword', search_log.type

      search_log = SearchLog.new(terms: '1500-1600', type: 'daterange')
      assert search_log.save
      assert_equal 'daterange', search_log.type
    end
  end
end
