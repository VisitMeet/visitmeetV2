# spec/factories/location_tags.rb

FactoryBot.define do
  factory :location_tag do
    sequence(:location) { |n| "location#{n}" }
  end
end
