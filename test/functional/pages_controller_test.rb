require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  tests HighVoltage::PagesController

  test 'can get static pages' do
    %w(about help).each do |page|
      get :show, params: {id: page}

      assert_response :success
      assert_template page
      end
  end
end