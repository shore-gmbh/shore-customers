require 'faraday'
require 'faraday_middleware'
require_relative 'customer_endpoints'
require_relative 'webhook_endpoints'
require_relative 'attribute_definition_endpoints'

module Shore
  module Customers # :nodoc:
    class Client # :nodoc:
      include CustomerEndpoints
      include WebhookEndpoints
      include AttributeDefinitionEndpoints

      # @param options [Hash]
      # @option options [String] :base_uri Base uri of the Customer Store http
      #   service. Defaults to `ENV['CUSTOMER_STORE_BASE_URI']`.
      # @option options [String] :secret Basic authentication secret for the
      #   Customer Store. Defaults to `ENV['CUSTOMER_STORE_SECRET']`
      def initialize(options = {})
        initialize_conn(options)
      end

      private

      attr_reader :conn

      def initialize_conn(options)
        base_url = options[:base_uri] || ENV['CUSTOMER_STORE_BASE_URI']
        fail initialize_failure if base_url.blank?
        secret = options[:secret] || ENV['CUSTOMER_STORE_SECRET']

        @conn = Faraday.new(url: base_url) do |faraday|
          # TODO@am: Configure Faraday here
          # faraday.request  :url_encoded
          # faraday.response :logger
          faraday.response :json, content_type: 'application/json'
          faraday.adapter Faraday.default_adapter
          faraday.basic_auth(secret, '')
        end
        @conn.headers = { 'Content-Type' => 'application/json' }
      end
    end

    def initialize_failure
      "Error: #{self.class} must be initialized with a :base_url \
      option or env variable CUSTOMER_STORE_BASE_URI must be set."
    end
  end
end
