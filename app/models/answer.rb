class Answer < ActiveRecord::Base
  belongs_to :question
  validates :body, presence: true, length: { in: 30..30000 }
  validates :question, presence: true
end
