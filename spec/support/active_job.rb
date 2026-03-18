require 'rspec/rails'
require 'active_job/test_helper'

RSpec.configure do |config|
  config.include ActiveJob::TestHelper
end
