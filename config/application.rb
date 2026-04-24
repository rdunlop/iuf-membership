# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Iuf
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.paypal_client_id = ENV['PAYPAL_CLIENT_ID']
    config.paypal_secret = ENV['PAYPAL_SECRET']
    config.paypal_mode = ENV.fetch('PAYPAL_MODE') { 'test' }

    config.membership_cost = ENV['MEMBERSHIP_COST']
    config.currency = ENV['CURRENCY']

    config.aws_access_key_id = ENV['AWS_ACCESS_KEY_ID']
    config.aws_secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    config.aws_region = ENV.fetch('AWS_REGION') { 'us-east-1' }
    config.email_from = ENV.fetch('EMAIL_FROM') { 'example@example.com' }

    config.rollbar_access_token = ENV['ROLLBAR_ACCESS_TOKEN']
    config.rollbar_env = ENV.fetch('ROLLBAR_ENV') { Rails.env }
    config.rollbar_client_access_token = ENV['ROLLBAR_CLIENT_ACCESS_TOKEN']

    config.server_hostname = ENV.fetch('SERVER_HOSTNAME') { 'localhost' }
    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks capistrano])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
