# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'simplecov'
require 'simplecov-json'
require 'webmock/rspec'

WebMock.disable_net_connect!

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
                                                                  SimpleCov::Formatter::HTMLFormatter,
                                                                  SimpleCov::Formatter::JSONFormatter
                                                                ])

SimpleCov.start :rails do
  enable_coverage :line
  add_group 'Services', 'app/services'
  add_group 'Models', 'app/models'
  add_group 'Workers', 'app/workers'
  minimum_coverage 40
  maximum_coverage_drop 2
  coverage_dir 'tmp/coverage'
  add_filter '/app/channels'
  add_filter '/app/mailers'
end
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.include ActiveSupport::Testing::TimeHelpers
  config.include Helpers
  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # Configure FactoryBot
  config.include FactoryBot::Syntax::Methods
  config.before(:suite) do
    Rails.application.load_tasks
  end
end

# Configure Shoula matchers
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  # This is the directory where VCR will store its "cassettes", i.e. its
  # recorded HTTP interactions.
  c.cassette_library_dir = 'spec/cassettes'

  # This line makes it so VCR and WebMock know how to talk to each other.
  c.hook_into :webmock

  # This line makes VCR ignore requests to localhost. This is necessary
  # even if WebMock's allow_localhost is set to true.
  c.ignore_localhost = true

  # ChromeDriver will make requests to chromedriver.storage.googleapis.com
  # to (I believe) check for updates. These requests will just show up as
  # noise in our cassettes unless we tell VCR to ignore these requests.
  c.ignore_hosts 'chromedriver.storage.googleapis.com'

  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == 'ASCII-8BIT' ||
      !http_message.body.valid_encoding?
  end

  # Private environment variables must be set during test run to generate real data for the VCR
  # They then are then hidden
  env_keys = %w[
    BUCKETEER_AWS_SECRET_ACCESS_KEY
    BUCKETEER_BUCKET_NAME
    OKC_BLOTTER_AUTH_TOKEN
    OKC_BLOTTER_AUTH_TOKEN
    BUCKETEER_AWS_ACCESS_KEY_ID
    AWS_LAMBDA_KEY
    AWS_LAMBDA_SECRET
    AWS_LAMBDA_REGION
    CENSUS_KEY
  ]
  env_keys.each do |key|
    c.filter_sensitive_data("<#{key}>") { ENV.fetch(key, nil) }

    ENV[key] = key unless ENV[key]
  end
end
