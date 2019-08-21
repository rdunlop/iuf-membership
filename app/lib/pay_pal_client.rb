# frozen_string_literal: true

# https://developer.paypal.com/docs/checkout/reference/server-integration/setup-sdk/#set-up-the-environment
module PayPalClient
  class << self
    # Set up and return PayPal Ruby SDK environment with PayPal access credentials.
    # This sample uses SandboxEnvironment. In production, use LiveEnvironment.
    def environment
      client_id = Rails.configuration.paypal_client_id
      client_secret = Rails.configuration.paypal_secret
      if Rails.configuration.paypal_mode == 'test'
        PayPal::SandboxEnvironment.new(client_id, client_secret)
      else
        PayPal::LiveEnvironment.new(client_id, client_secret)
      end
    end

    # Returns PayPal HTTP client instance with environment that has access
    # credentials context. Use this instance to invoke PayPal APIs, provided the
    # credentials have access.
    def client
      PayPal::PayPalHttpClient.new(environment)
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
    def array_to_hash(array, hash = [])
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
