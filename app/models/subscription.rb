class Subscription < ActiveRecord::Base
  belongs_to :user
  belongs_to :subscriber, class_name: User, foreign_key: :user_id
  belongs_to :question

  validates :user_id, :question_id, presence: true
  
end
