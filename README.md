# VisitMeet: Airbnb for Underserved Communities

VisitMeet is a Ruby on Rails web application inspired by Airbnb & Couchsurfing, designed to empower underserved communities around the world by connecting users with unique, local activities and experiences. Users can sign up, create profiles, list activities, search and book experiences, and leave reviews—helping local hosts reach a global audience.

## Features
- User authentication (sign up, log in, log out)
- Profile management
- Activity listings with images, location, price, and description
- Search and filter activities by tags and location
- Booking system for activities
- Reviews and ratings for activities
- Admin dashboard for managing users, activities, and bookings
- Responsive design with Tailwind CSS
- Multi-language and multi-currency support

## Getting Started

### Prerequisites
- Ruby (version specified in `.ruby-version` or `Gemfile`)
- Rails (see `Gemfile`)
- PostgreSQL or SQLite (as configured in `config/database.yml`)
- Node.js and Yarn
- Chrome browser (for system tests)

### Setup
1. **Clone the repository:**
   ```sh
   git clone https://github.com/yourusername/visitmeet.git
   cd visitmeet
   ```
2. **Install dependencies:**
   ```sh
   bundle install
   yarn install --check-files
   ```
3. **Set up the database:**
   ```sh
   bin/rails db:setup
   ```
4. **Start the Rails server:**
   ```sh
   bin/rails server
   ```
5. **Visit the app:**
   Open [http://localhost:3000](http://localhost:3000) in your browser.

### Running the Test Suite
- Run all tests:
  ```sh
  bundle exec rspec
  ```
- Feature/system tests will open a browser window for visible testing (see `spec/features/authentication_spec.rb`).

### Deployment
- Standard Rails deployment (Heroku, Render, etc.)
- Ensure environment variables and database are configured for production.

### Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

### License
[MIT](LICENSE)

---

**VisitMeet** — Find and book authentic activities in underserved communities worldwide!
