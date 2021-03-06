require_relative 'customer_stubs'
require_relative 'attribute_definition_stubs'

module Shore
  module Customers
    module Rspec
      class ServiceMock # :nodoc:
        include WebMock::API
        include CustomerStubs
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
end
