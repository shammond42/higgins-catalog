require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    FactoryGirl.create(:user)
  end

  should validate_presence_of(:email).with_message(/All.*users/)
  should validate_presence_of(:name).with_message(/Please.*name/)
  should validate_presence_of(:title).with_message(/title/)

  should_not allow_mass_assignment_of(:id)
  should_not allow_mass_assignment_of(:created_at)
  should_not allow_mass_assignment_of(:updated_at)

  # Devise fields
  should_not allow_mass_assignment_of(:encrypted_password)
  should_not allow_mass_assignment_of(:reset_password_token)
  should_not allow_mass_assignment_of(:reset_password_sent_at)
  should_not allow_mass_assignment_of(:remember_created_at)
  should_not allow_mass_assignment_of(:sign_in_count)
  should_not allow_mass_assignment_of(:current_sign_in_at)
  should_not allow_mass_assignment_of(:last_sign_in_at)
  should_not allow_mass_assignment_of(:current_sign_in_ip)
  should_not allow_mass_assignment_of(:last_sign_in_ip)

  should allow_mass_assignment_of(:email)
  should allow_mass_assignment_of(:name)
  should allow_mass_assignment_of(:title)
  should allow_mass_assignment_of(:password)
  should allow_mass_assignment_of(:password_confirmation)
  should allow_mass_assignment_of(:remember_me)
end
