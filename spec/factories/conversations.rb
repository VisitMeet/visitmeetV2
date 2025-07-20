FactoryBot.define do
  factory :conversation do
    association :sender, factory: :user
    association :recipient, factory: :user

    trait :with_messages do
      transient do
        messages_count { 3 }
      end

      after(:create) do |conversation, evaluator|
        create_list(:message, evaluator.messages_count, conversation: conversation, user: conversation.sender)
      end
    end
  end
end