FactoryGirl.define do
  factory :question do
    sequence(:body) { |n| "Much question much confusion#{n}" }
    sequence(:title) { |n| "How to sort in O(n)?#{n}" }
    user
  end
end
