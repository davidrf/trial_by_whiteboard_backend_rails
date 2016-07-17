FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "Answer #{n}" }
    question
    user
  end
end
