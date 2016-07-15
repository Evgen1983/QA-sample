class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  validates :content, presence: true, length: { maximum: 1000 }
end
