
require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'mocha/setup'

HigginsCatalog::Application.config.rakismet.test = true

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  def deny(boolean, message = nil)
    assert ! boolean, message
  end
end

class ActionController::TestCase
    include Devise::TestHelpers
end