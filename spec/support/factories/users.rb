FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "george_michael_#{n}" }
    sequence(:email) { |n| "gm#{n}@example.com" }
    password "password"
    authentication_token { SecureRandom.base58(24) }
    authentication_token_expires_at ENV.fetch("AUTHENTICATION_TOKEN_DURATION_IN_DAYS") { 7 }.to_i.days.from_now
  end
end
