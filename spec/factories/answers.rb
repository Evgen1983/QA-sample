FactoryGirl.define do
  factory :answer do
    body "MyText is not too short, because it contains more than 30 characters"
    question nil
  end
end
