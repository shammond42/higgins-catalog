
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/setup'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  def deny(boolean, message = nil)
    message = build_message message, '<?> is not false or nil.', boolean
    assert_block message do
      not boolean
    end
  end
end

class ActionController::TestCase
    include Devise::TestHelpers
end