require 'rspec/rails'
require 'database_cleaner/active_record'

RSpec.configure do |config|
  config.before(:suite) do
    # Clean out the database state before the tests run
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
