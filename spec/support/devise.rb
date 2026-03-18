require 'rspec/rails'

if defined?(Warden)
  include Warden::Test::Helpers
  Warden.test_mode!
end

if defined?(Devise)
  RSpec.configure do |config|
    config.before(:each, type: :controller) do
      @request.env['devise.mapping'] = Devise.mappings[:spree_user]
    end

    config.include Devise::Test::ControllerHelpers, type: :controller

    config.include Warden::Test::Helpers
    config.before :suite do
      Warden.test_mode!
    end
  end
end
