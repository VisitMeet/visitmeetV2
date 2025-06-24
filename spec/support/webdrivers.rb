# spec/support/webdrivers.rb
require 'webdrivers/geckodriver'

# Use the matching Geckodriver for Firefox
Webdrivers::Geckodriver.required_version = '0.33.0'
Webdrivers::Geckodriver.update