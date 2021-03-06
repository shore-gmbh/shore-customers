require 'shore/customers/rspec/call_customer_store_matcher'
require 'shore/customers/rspec/service_mock'

module Shore
  module Customers
    module Rspec # :nodoc:
      DEFAULT_BASE_URI = 'http://css-test.shore.com'.freeze

      def customer_store(base_uri = DEFAULT_BASE_URI)
        ServiceMock.new(base_uri)
      end
    end
  end
end
