class Question < ActiveRecord::Base
  include Votable
  include Attachable
  include Commentable
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions
  validates :title, presence: true, length: { in: 15..150 }
  validates :body, presence: true, length: { in: 30..30000 }
  validates :user_id, presence: true

  scope :yesterday, -> { where(created_at: Time.zone.yesterday.to_time.all_day) }

  after_create :subscribe_author

  def subscribe(user)
    self.subscribers << user unless subscribed?(user)
  end

  def unsubscribe(user)
    self.subscribers.delete(user) if subscribed?(user)
  end

  def subscribed?(user)
    subscribers.include?(user)
  end

  private

  def subscribe_author
    subscribe(user)
  end
end
