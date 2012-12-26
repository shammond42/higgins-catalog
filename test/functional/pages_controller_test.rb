require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  tests HighVoltage::PagesController

  test 'can get static pages' do
    %w(about dedication help).each do |page|
      get :show, :id => page 

      assert_response :success
      assert_template page
      end
  end
end