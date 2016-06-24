class Answer < ActiveRecord::Base
  default_scope { order(best: :desc) }

  belongs_to :question
  belongs_to :user
  validates :body, presence: true, length: { in: 30..30000 }
  validates :question, presence: true
  has_many :attachments, as: :attachable
  accepts_nested_attributes_for :attachments

  def set_best!
    transaction do
      question.answers.update_all(best: false)
      self.update!(best: true)
    end
end
end
