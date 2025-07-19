# spec/factories/location_tags.rb

FactoryBot.define do
  factory :location_tag do
    # use a unique sequence so you can create multiple different tags if needed
    location { "validlocation" }
  end
end