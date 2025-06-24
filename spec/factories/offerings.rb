FactoryBot.define do
  factory :offering do
    title { "Amazing Local Photography Tour" }
    description { "Join me for a unique photography experience exploring hidden gems in the city. We'll visit local spots that only locals know about, perfect for capturing authentic moments." }
    price { 75.00 }
    location { "tokyo" }
    association :user
  end
end
