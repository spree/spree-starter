require 'webdrivers/chromedriver'
require 'capybara'

RSpec.configure do |config|
  config.before(:each) do
    Capybara.match = :smart
    Capybara.javascript_driver = :selenium_chrome_headless
    Capybara.default_max_wait_time = 10
    Capybara.raise_server_errors = false
  end
end
