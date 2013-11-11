class Question < ActiveRecord::Base
  include Rakismet::Model
  attr_accessible :answer, :question, :nickname, :email, :is_spam
  belongs_to :artifact
  rakismet_attrs author: :nickname, author_email: :email, comment_type: 'comment',
    content: :question

  scope :unanswered, where('answer is null')
  scope :answered, where('answer is not null')
  scope :spam, where('is_spam = true')
  scope :not_spam, where('is_spam = false')
end
