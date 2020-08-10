require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create(:user)
  end

  # should validate_presence_of(:email).with_message(/All.*users/)
  # should validate_presence_of(:name).with_message(/Please.*name/)
  # should validate_presence_of(:title).with_message(/title/)
end
