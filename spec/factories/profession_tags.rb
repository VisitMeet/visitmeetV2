# spec/factories/profession_tags.rb

FactoryBot.define do
  factory :profession_tag do
    sequence(:profession) { |n| "profession#{n}" }
  end
end