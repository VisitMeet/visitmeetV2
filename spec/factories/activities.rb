FactoryBot.define do
  factory :activity do
    title { "MyString" }
    description { "MyText" }
    location { "MyString" }
    price { "9.99" }
    association :user
  end
end
