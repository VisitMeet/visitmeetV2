FactoryBot.define do
  factory :message do
    association :conversation
    association :user
    body { "MyText" }
  end
end