require 'factory_bot'
require 'rspec/rails'

FactoryBot.find_definitions

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
end

# enable factories decorators
Dir[Rails.root.join('spec/factories/spree/**/*.rb')].sort.each do |factory|
  require factory if factory =~ /decorator/
end
