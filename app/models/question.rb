class Question < ActiveRecord::Base
	include Votable
	include Attachable
	include Commentable
	belongs_to :user
	has_many :answers, dependent: :destroy
	validates :title, presence: true, length: { in: 15..150 }
	validates :body, presence: true, length: { in: 30..30000 }
	validates :user_id, presence: true

	scope :yesterday, -> { where(created_at: Time.zone.yesterday.to_time.all_day) }
end
