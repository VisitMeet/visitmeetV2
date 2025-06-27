source "https://rubygems.org"
ruby "3.3.5"
gem "rails", "~> 7.1.4"
# gem "sprockets-rails"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bootsnap", require: false
gem 'devise'


group :development, :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'factory_bot_rails' # For creating test data
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  gem "web-console"
end

group :test do
  gem 'rspec-rails' # Added RSpec gem
  gem "capybara"
  gem "selenium-webdriver"
  gem 'shoulda-matchers' # Added Shoulda Matchers gem
  gem 'simplecov', require: false # Added SimpleCov gem for test coverage
  gem "webdrivers" 
end

gem 'foreman'
gem 'newrelic_rpm'
gem 'rollbar'
gem "ostruct", "~> 0.6.0"
gem "logger", "~> 1.6"
# gem "tailwindcss-rails", "~> 2.7"
gem 'unsplash'
gem 'jquery-rails'
gem 'recaptcha', require: 'recaptcha/rails'
gem "image_processing", "~> 1.2"