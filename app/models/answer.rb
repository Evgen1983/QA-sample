class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { in: 30..30000 }
  validates :question, presence: true
  

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
end
end
