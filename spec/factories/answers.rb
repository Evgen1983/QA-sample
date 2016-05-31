FactoryGirl.define do
 
  factory :answer do
    body "MyText is not too short, because it contains more than 30 characters"
    question
    user
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
