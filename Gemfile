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

# Rails must load before Propshaft (its railtie only registers once Rails is
# present), and Propshaft before the Spree gems.
gem 'rails', '~> 8.1.2'
gem 'propshaft'

# Spree Commerce
spree_path = ENV.fetch('SPREE_PATH', nil)

if spree_path
  # Bundler's default path glob stops two levels deep; the extra level
  # reaches provider gems under spree/providers/*.
  path "#{spree_path}/spree", glob: '{,*,*/*,*/*/*}.gemspec' do
    gem 'spree'
    gem 'spree_core'
    gem 'spree_api'
    gem 'spree_dashboard'
    gem 'spree_easypost'
    gem 'spree_emails'
  end
else
  spree_version = { github: 'spree/spree', branch: 'main', 'glob': 'spree/**/*.gemspec' }
  gem 'spree', spree_version
  gem 'spree_emails', spree_version
  gem 'spree_dashboard', spree_version
end

# Extensions
gem 'spree_i18n'
# spree_stripe is off the 6.0 line until Stripe moves into the monorepo with
# its tax calculator rewritten as a Spree.tax_provider adapter.
# gem 'spree_adyen'
# gem 'spree_paypal_checkout'

# Rails & Infrastructure
gem 'aws-sdk-s3', require: false
gem 'bootsnap', require: false
gem 'image_processing', '~> 1.2'
gem 'lograge'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'sentry-rails'
gem 'sentry-ruby'
# The Solid stack: jobs, cache, and Action Cable in Postgres — no extra
# service to run.
gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'
# Job dashboard at /jobs
gem 'mission_control-jobs'
gem 'rack-cors'
gem 'thruster', require: false

# Search — client for the optional Meilisearch provider; product search runs
# on the database unless MEILISEARCH_URL is set
gem 'meilisearch', '>= 0.28'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv-rails'
  gem 'rubocop-rails-omakase', require: false
  gem 'simplecov-cobertura'
  gem 'spree_dev_tools'
end

group :development do
  gem 'web-console'
end
