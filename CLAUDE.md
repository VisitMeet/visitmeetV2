# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Database
- `rails db:create` - Create development and test databases
- `rails db:migrate` - Run pending migrations
- `rails db:seed` - Load seed data
- `rails db:reset` - Drop, recreate, migrate, and seed databases
- `rails db:prepare` - Setup database or run migrations if exists

### Testing
- `bundle exec rspec` - Run all RSpec tests
- `bundle exec rspec spec/models` - Run model tests only
- `bundle exec rspec spec/controllers` - Run controller tests only
- `bundle exec cucumber` - Run all Cucumber BDD features
- `bundle exec cucumber features/create_offering.feature` - Run specific feature
- `rails test` - Run all Minitest tests (legacy)

### Development Server
- `foreman start -f Procfile.dev` - Start Rails server with Tailwind CSS watching (recommended)
- `rails server` - Start Rails server only
- `rails tailwindcss:watch` - Watch and rebuild Tailwind CSS

### Asset Management
- `rails tailwindcss:build` - Build Tailwind CSS for production
- `rails assets:precompile` - Compile all assets

## Architecture Overview

### User Authentication & Authorization
- Uses Devise for authentication with custom login (username OR email)
- Users can authenticate with either username or email address
- Custom registration/session controllers in `app/controllers/users/`

### Tag System Architecture
The application uses a multi-type tagging system:

1. **Legacy Tag System**: Generic `Tag` model with `UserTag` join table (being phased out)
2. **Location Tags**: `LocationTag` → `UserLocationTag` → `User` associations
3. **Profession Tags**: `ProfessionTag` → `UserProfessionTag` → `User` associations

**Key Models:**
- `User` - Central user model with Devise authentication
- `LocationTag` - Stores location data (lowercase format enforced)
- `ProfessionTag` - Stores profession data (lowercase format enforced) 
- `UserLocationTag` & `UserProfessionTag` - Join tables for many-to-many relationships

### Core Features
- **Profiles**: Users can view profiles and add/remove location and profession tags
- **Offerings**: Users can create offerings (work in progress)
- **Search/Results**: Tag-based search functionality
- **Home Page**: Landing page with authentication

### Frontend Stack
- **CSS Framework**: Tailwind CSS with live reloading in development
- **JavaScript**: Stimulus controllers with Importmap
- **Libraries**: jQuery for DOM manipulation, autocomplete functionality

### Database
- **PostgreSQL** for all environments
- Environment variables: `PG_USERNAME`, `PG_PASSWORD` for development
- Production uses `VISITMEET_V2_DATABASE_PASSWORD`

### Testing Strategy
- **RSpec** for unit/integration tests with FactoryBot factories
- **Cucumber** for BDD feature tests
- **Minitest** for some legacy tests
- **Capybara + Selenium** for system tests

### Key Directories
- `app/models/` - Domain models, focus on User and tag-related models
- `app/controllers/` - RESTful controllers, custom Devise controllers
- `app/views/` - ERB templates with Tailwind styling
- `spec/` - RSpec tests with factories
- `features/` - Cucumber BDD scenarios
- `db/migrate/` - Database migrations (check recent ones for current schema)