class User < ActiveRecord::Base
  attr_accessible :email, :name, :title

  validates_presence_of :email, message: 'All users must have an e-mail address.'
  validates_presence_of :name, message: 'Please enter the name for this user.'
  validates_presence_of :title, message: "What is this user's title."
end
