FactoryBot.define do
  factory :review do
    association :user
    association :offering
    rating { 5 }
    comment { "Great experience!" }
  end
end
