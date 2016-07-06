FactoryGirl.define do
  factory :comment do
    content "MyText"
    commentable_id 1
    commentable_type "MyString"
    user nil
    commentable nil
  end
end
