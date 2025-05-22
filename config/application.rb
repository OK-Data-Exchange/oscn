require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
# require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module BackendTemplate
  class Application < Rails::Application
    config.load_defaults 7.0

    # Add this for Sidekiq UI
    config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies

    config.middleware.use config.session_store, config.session_options
    config.active_record.encryption.primary_key = 'NVeQ36vQTvUr7knoqvYmQuHD920mTNsA'
    config.active_record.encryption.deterministic_key = 'YAJ7rtZV5yAjfzglp9iwzMKj4zGFpxZW'
    config.active_record.encryption.key_derivation_salt = 'qCSMq3kA0e9BWC0KifsJDFUXpRU9I67J'
    config.credentials.content_path = 'config/credentials.yml.enc'


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = false
    config.time_zone = 'Central Time (US & Canada)'
    config.hosts << "criminal-justice-app-341c15dd4383.herokuapp.com"
  end
end
