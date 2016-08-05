class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :short_title, :created_at, :updated_at
  has_many :answers
 
  def short_title
    object.title.truncate(10)
  end
end
