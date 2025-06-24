FactoryBot.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:full_name) { |n| "User #{n} Full Name" }
    password { "password123" }
    password_confirmation { "password123" }
  end
end