FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    location { "Somewhere" }
    bio { "Adventure enthusiast" }
  end
end