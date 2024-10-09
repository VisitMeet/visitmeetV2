# Clear existing data to avoid duplicates
LocationTag.destroy_all
ProfessionTag.destroy_all

# Seed Location Tags (Tourist Destinations in Nepal)
locations = [
  "pokhara", "dolpa", "apihimal", "kathmandu", "mustang", "lamjung", "manang", "lumbini", "bhaktapur", "sagarmatha", 
  "janakpur", "illam", "chitwan", "bardiya", "rara", "gosaikunda", "palpa", "sindhuli", "namche bazaar", "tansen", 
  "jomsom", "baglung", "damak", "tumlingtar", "biratnagar", "dharan", "dhankuta", "okhaldhunga", "bhojpur", "besisahar",
  "solukhumbu", "nuwakot", "bajura", "bajhang", "dadeldhura", "mahendranagar", "birtamod", "taplejung", "barhabise",
  "dolakha", "simikot", "jumla", "khaptad", "shuklaphanta", "phoksundo", "tilicho", "syangboche", "lukla", "bandipur",
  "dhulikhel", "panauti", "tansen", "ghale gaun", "ridi bazar", "patihani", "bhojpur", "kalinchowk", "daman", "ramkot",
  "jatayu", "pikey peak", "dhankuta", "phalankharaka", "gaur", "larke pass", "ganesh himal", "dhorpatan", "siddharthanagar",
  "jumla", "muktinath", "tindhare", "thamel", "nagarkot", "balthali", "chandragiri", "bhote koshi", "barpak", "salyan",
  "radhakrishna temple", "sankhu", "swargadwari", "ilam bazaar", "gorkha", "birgunj", "parsa", "sauraha", "devghat", "bardibas",
  "ranikot", "kalaiya", "koshi tappu", "birgunj", "mechinagar", "pathivara", "taplejung", "itahari", "malekhu", "lamahi",
  "tansen", "pyuthan", "gaurishankar", "shree antu", "makwanpur", "surkhet", "dipayal", "khotang", "martadi", "birendranagar",
  "gokyo", "melamchi", "palung", "nawalparasi", "sindhuli", "gaur", "butwal", "bhoteodar", "besishahar", "sankhuwasabha",
  "sanfe bagar", "salleri", "sirkot", "khaireni", "bijayapur", "myagdi", "darchula", "sankhuwasabha", "taplejung", "patlekhet",
  "bhaktapur", "siddhicharan", "gorkha", "jumla", "yala", "karnali"
]

# Seed Profession Tags
professions = [
  "cyclist", "climber", "paragliding pilot", "trekking guide", "photographer", "yoga instructor", "wildlife biologist", 
  "scuba diving instructor", "mountain guide", "cultural historian", "birdwatcher", "adventure coach", "rafting guide",
  "kayak instructor", "jeep safari guide", "bungee jump operator", "paraglider", "rock climber", "ski instructor", "snowboard coach",
  "forest ranger", "botanist", "geologist", "environmentalist", "cave explorer", "skydiving instructor", "mountain biker",
  "trail runner", "expedition leader", "meditation coach", "nature photographer", "food guide", "heritage guide", "mountaineer",
  "travel blogger", "documentary filmmaker", "pilgrim guide", "mountain rescue", "volunteer coordinator", "ecologist",
  "adventure racer", "tour guide", "historian", "park ranger", "sustainability expert", "eco-tourism consultant", "camping expert",
  "forest guide", "tea connoisseur", "archaeologist", "stargazing expert", "nature artist", "travel writer", "adventure planner",
  "survival expert", "rappelling guide", "river guide", "photography instructor", "temple architect", "folk artist",
  "helicopter pilot", "weather expert", "cultural expert", "conservationist", "forest tracker", "animal tracker", "zoologist",
  "hiking guide", "ice climber", "mountain chef", "pilgrimage leader", "river rafting expert", "safari tour guide", "ethnologist",
  "marine biologist", "nature expert", "astrophotographer", "glacier expert", "aviation expert", "snorkeling guide", "hot air balloon pilot",
  "park ranger", "wildlife photographer", "festival coordinator", "expedition medic", "mountain flight pilot", "wind glider",
  "sherpa", "camp cook", "eco guide", "yogi", "climate researcher", "mountain porter", "snowboard guide", "himalayan researcher",
  "adventure therapist", "waterfall guide", "lodge manager", "offroad driver", "village tour expert", "sustainable tourism advisor"
]

# Creating Location Tags
locations.each do |location|
  LocationTag.create(location: location)
end

puts "#{locations.count} Location tags seeded successfully."

# Creating Profession Tags
professions.each do |profession|
  ProfessionTag.create(profession: profession)
end

puts "#{professions.count} Profession tags seeded successfully."