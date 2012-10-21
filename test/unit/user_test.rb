require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    User.new(name: 'Frodo Baggins', email: 'fbaggins@bagend.com', title: 'Ring Bearer').save!
  end

  should validate_presence_of(:email).with_message(/All.*users/)
  should validate_presence_of(:name).with_message(/Please.*name/)
  should validate_presence_of(:title).with_message(/title/)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  should allow_mass_assignment_of(:email)
  should allow_mass_assignment_of(:name)
  should allow_mass_assignment_of(:title)
end
