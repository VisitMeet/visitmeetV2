FactoryBot.define do
  factory :booking do
    association :user
    association :offering
    requested_date { 1.week.from_now.to_date }
    guests { 2 }
    message { "Looking forward to this local experience!" }
    status { :pending }
    total_amount { 100.00 }

    trait :accepted do
      status { :accepted }
    end

    trait :declined do
      status { :declined }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :completed do
      status { :completed }
      requested_date { 1.week.ago.to_date }
    end
  end
end
