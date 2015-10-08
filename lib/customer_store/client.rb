require 'customer_store/client/version'

require 'faraday'
require_relative 'customer_endpoints'
require_relative 'webhook_endpoints'
require_relative 'attribute_definition_endpoints'

module CustomerStore
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
      fail "Error: CustomerStore::Service must be initialized with a \
:base_url option or env variable CUSTOMER_STORE_BASE_URI \
must be set." if base_url.blank?
      secret = options[:secret] || ENV['CUSTOMER_STORE_SECRET']

      @conn = Faraday.new(url: base_url) do |faraday|
        # TODO@am: Configure Faraday here
        # faraday.request  :url_encoded
        # faraday.response :logger
        faraday.adapter Faraday.default_adapter
        faraday.basic_auth(secret, '')
      end
    end

    def format_response(response)
      formatted = {
        'status' => response.status,
        'headers' => response.headers
      }
      if (body = response.body).present? &&
         response.headers['content-type'] == 'application/json'
        body = JSON(body)
      end
      formatted['body'] = body
      formatted
    end
  end
end
