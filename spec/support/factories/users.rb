FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "george_michael_#{n}" }
    sequence(:email) { |n| "gm#{n}@example.com" }
    password "password"
  end
end
