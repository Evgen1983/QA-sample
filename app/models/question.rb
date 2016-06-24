class Question < ActiveRecord::Base
	belongs_to :user
	has_many :answers, dependent: :destroy
	has_many :attachments
	validates :title, presence: true, length: { in: 15..150 }
	validates :body, presence: true, length: { in: 30..30000 }
	validates :user_id, presence: true
	accepts_nested_attributes_for :attachments
end
