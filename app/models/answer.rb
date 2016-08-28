class Answer < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  default_scope { order(best: :desc) }

  belongs_to :question, touch: true
  belongs_to :user
  validates :body, presence: true, length: { in: 30..30000 }
  validates :question, presence: true
  
  after_commit :sent_notice, on: :create

  def set_best!
    transaction do
      question.answers.update_all(best: false, updated_at: Time.now)
      self.update!(best: true)
    end
  end

  private
    def sent_notice
      NewAnswerNoticeJob.perform_now(self)
  end
end
