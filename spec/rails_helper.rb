# spec/rails_helper.rb

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Load support files
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include Shoulda::Matchers::ActiveRecord, type: :model
  config.include Shoulda::Matchers::ActiveModel, type: :model
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Devise::Test::IntegrationHelpers, type: :system
  config.include Devise::Test::ControllerHelpers, type: :view
  config.include Devise::Test::ControllerHelpers, type: :controller

  require 'selenium/webdriver'

  Capybara.register_driver :selenium_firefox do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('-headless')
    options.binary = '/Applications/Firefox.app/Contents/MacOS/firefox' # Explicitly set Firefox binary path
    Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
  end

  Capybara.javascript_driver = :selenium_firefox
  Capybara.default_driver = :selenium_firefox
  Capybara.default_max_wait_time = 5

  # Fixture files location
  config.fixture_path = "#{Rails.root}/spec/fixtures"

  # Use transactions for tests
  config.use_transactional_fixtures = true

  # Infer spec type (model, controller, system, etc.) from file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtraces
  config.filter_rails_from_backtrace!

  Capybara.javascript_driver = :selenium_firefox
  Capybara.default_driver = :selenium_firefox
end
