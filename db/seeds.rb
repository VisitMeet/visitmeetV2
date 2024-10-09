# Clear existing data to avoid duplicates
LocationTag.destroy_all
ProfessionTag.destroy_all

# Seed Location Tags
locations = ["pokhara", "dolpa", "apihimal", "kathmandu", "mustang", "lamjung", "manang"]
locations.each do |location|
  LocationTag.create(location: location)
end

puts "Location tags seeded successfully."

# Seed Profession Tags
professions = ["cyclist", "climber", "paragliding pilot", "trekking guide", "photographer", "yoga instructor", "wildlife biologist"]
professions.each do |profession|
  ProfessionTag.create(profession: profession)
end

puts "Profession tags seeded successfully."