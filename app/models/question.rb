class Question < ActiveRecord::Base
  attr_accessible :answer, :question, :nickname, :email
  belongs_to :artifact

  scope :unanswered, where('answer is null')
  scope :answered, where('answer is not null')
end
