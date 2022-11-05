require 'capybara/rails'
require 'capybara/rspec'
require 'selenium/webdriver'
require 'capybara-screenshot/rspec'

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  config.javascript_driver = :headless_chrome
  config.default_max_wait_time = 5
end

Capybara::Screenshot.autosave_on_failure = false
