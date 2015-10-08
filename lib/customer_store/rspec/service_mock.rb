require_relative 'customer_stubs'
require_relative 'webhook_stubs'
require_relative 'attribute_definition_stubs'

module CustomerStore
  module Rspec
    class ServiceMock # :nodoc:
      include WebMock::API
      include CustomerStubs
      include WebhookStubs
      include AttributeDefinitionStubs

      attr_reader :base_uri

      def initialize(base_uri)
        @base_uri = base_uri
      end

      # @return WebMock::RequestStub
      def stub_any_request
        stub_request(:any, %r{#{base_uri}(?:\/.*)?})
      end
    end
  end
end
