FactoryGirl.define do
  sequence :title do |n|
    "MyString is not too short#{n}"
  end
  sequence :body do |n|
    "MyText is not too short, because it contains more than 30 characters#{n}"
  end

  factory :question do
    title 
    body
    user
    trait :with_attachment do
      after(:create) { |question| create(:attachment, attachable: question) }
    end  
  end

  factory :invalid_question, class: "Question" do
    title nil
    body nil
  end
end
