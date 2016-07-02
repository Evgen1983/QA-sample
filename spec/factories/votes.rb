FactoryGirl.define do
  factory :vote do
    score 1
    votable_id 1
    votable_type "MyString"
    user nil
    votable nil
  end
end
