class AnswerPreviewSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :created_at, :updated_at, :question_id
  has_many :comments
  has_many :attachments
end