FactoryGirl.define do
  factory :question do
    title "MyString is not too short"
    body "MyText is not too short, because it contains more than 30 characters"
  end
end
