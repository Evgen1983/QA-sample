class Question < ActiveRecord::Base
	include Votable
	belongs_to :user
	has_many :answers, dependent: :destroy
	has_many :attachments, as: :attachable, dependent: :destroy
	validates :title, presence: true, length: { in: 15..150 }
	validates :body, presence: true, length: { in: 30..30000 }
	validates :user_id, presence: true
	accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
end
