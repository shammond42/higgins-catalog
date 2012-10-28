class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable
         #:registerable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :title

  validates_presence_of :email, message: 'All users must have an e-mail address.'
  validates_presence_of :name, message: 'Please enter the name for this user.'
  validates_presence_of :title, message: "What is this user's title."
end
