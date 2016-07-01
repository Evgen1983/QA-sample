FactoryGirl.define do
  factory :attachment do
    file { File.open("#{Rails.root}/public/robots.txt") }
  end
end
