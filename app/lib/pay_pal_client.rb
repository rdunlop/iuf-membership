# frozen_string_literal: true
require "paypal_server_sdk"

# https://developer.paypal.com/docs/checkout/reference/server-integration/setup-sdk/#set-up-the-environment
module PayPalClient
  class << self
    # Set up and return PayPal Ruby SDK environment with PayPal access credentials.
    # This sample uses SandboxEnvironment. In production, use LiveEnvironment.
    def environment
      if Rails.configuration.paypal_mode == 'test'
        PaypalServerSdk::Environment::SANDBOX
      else
        PaypalServerSdk::Environment::PRODUCTION
      end
    end

    # Returns PayPal HTTP client instance with environment that has access
    # credentials context. Use this instance to invoke PayPal APIs, provided the
    # credentials have access.
    def client
      PaypalServerSdk::Client.new(
        client_credentials_auth_credentials: PaypalServerSdk::ClientCredentialsAuthCredentials.new(
          o_auth_client_id: Rails.configuration.paypal_client_id,
          o_auth_client_secret: Rails.configuration.paypal_secret
        ),
        environment: environment,
        logging_configuration: PaypalServerSdk::LoggingConfiguration.new(
          log_level: Logger::INFO,
          request_logging_config: PaypalServerSdk::RequestLoggingConfiguration.new(
            log_body: true
          ),
          response_logging_config: PaypalServerSdk::ResponseLoggingConfiguration.new(
            log_headers: true
          )
        )
      )
    end

    # Utility to convert Openstruct Object to JSON hash.
    def openstruct_to_hash(object, hash = {})
      object.each_pair do |key, value|
        hash[key] = if value.is_a?(OpenStruct)
                      openstruct_to_hash(value)
                    elsif value.is_a?(Array)
                      array_to_hash(value)
                    else
                      value
                    end
      end
      hash
    end

    # Utility to convert array of OpenStruct to hash.
    def array_to_hash(array, hash = []) # rubocop:disable Metrics/MethodLength
      array.each do |item|
        x = if item.is_a?(OpenStruct)
              openstruct_to_hash(item)
            elsif item.is_a?(Array)
              array_to_hash(item)
            else
              item
            end
        hash << x
      end
      hash
    end
  end
end
