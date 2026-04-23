# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

# Load .env for SPREE_PATH (dotenv-rails only loads at Rails boot, not during bundle)
env_file = File.expand_path('.env', __dir__)
if File.exist?(env_file)
  File.readlines(env_file).each do |line|
    line = line.strip
    next if line.empty? || line.start_with?('#')

    key, value = line.split('=', 2)
    ENV[key] = value if key && value && !ENV.key?(key)
  end
end

# Spree Commerce
spree_path = ENV['SPREE_PATH']

if spree_path
  path "#{spree_path}/spree" do
    gem 'spree'
    gem 'spree_admin'
    gem 'spree_core'
    gem 'spree_api'
    gem 'spree_emails'
  end
else
  spree_version = '>= 5.4.0'
  gem 'spree', spree_version
  gem 'spree_admin', spree_version
end

# Extensions
gem 'spree_i18n'
gem 'spree_stripe'

# Rails & Infrastructure
gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'devise'
gem 'image_processing', '~> 1.2'
gem 'importmap-rails'
gem 'lograge'
gem 'pg', '~> 1.1'
gem 'propshaft'
gem 'puma', '>= 5.0'
gem 'rails', '~> 8.1.2'
gem 'redis'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sentry-sidekiq'
gem 'sidekiq'
gem 'stimulus-rails'
gem 'tailwindcss-rails'
gem 'thruster', require: false
gem 'turbo-rails'

# Search
gem 'meilisearch', '>= 0.28'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails'
  gem 'letter_opener'
  gem 'listen'
  gem 'rubocop-rails-omakase', require: false
  gem 'simplecov-cobertura'
  gem 'spree_dev_tools'
end

group :development do
  gem 'web-console'
end
