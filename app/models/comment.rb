class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true
  validates :content, presence: true, length: { maximum: 1000 }
  default_scope { order(created_at: :asc) }
end
