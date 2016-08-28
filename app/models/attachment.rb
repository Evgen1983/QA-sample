class Attachment < ActiveRecord::Base
  belongs_to :attachable, polymorphic: true, touch: true
  validates :file, presence: true
  mount_uploader :file, FileUploader
  delegate :url, to: :file
  
end
