# spec/support/capybara.rb

require 'capybara/rails'
require 'capybara/rspec'

# Register Firefox driver for Selenium
Capybara.register_driver :selenium_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new

  # macOS Firefox binary path
  options.binary = '/Applications/Firefox.app/Contents/MacOS/firefox'

  Capybara::Selenium::Driver.new(
    app,
    browser: :firefox,
    options: options
  )
end

# Default and JavaScript drivers
Capybara.default_driver        = :selenium_firefox
Capybara.javascript_driver     = :selenium_firefox
Capybara.default_max_wait_time = 5
