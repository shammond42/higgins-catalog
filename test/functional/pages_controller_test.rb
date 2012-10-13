require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  tests HighVoltage::PagesController

  test 'Can get static pages' do
    %w(index).each do |page|
      get :show, :id => page 

      assert_response :success
      assert_template page
      end
  end
end