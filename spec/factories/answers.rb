FactoryGirl.define do
 
  factory :answer do
    body "My Answer is not too short, because it contains more than 30 characters"
    question
    user
    best false
  end

  factory :invalid_answer, class: 'Answer' do
    body nil
    question nil
  end
end
