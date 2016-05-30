class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { in: 30..30000 }
  validates :question, presence: true
end
