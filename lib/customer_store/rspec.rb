require 'customer_store/rspec/call_customer_store_matcher'
require 'customer_store/rspec/service_mock'

module CustomerStore
  module Rspec # :nodoc:
    DEFAULT_BASE_URI = 'http://css-test.shore.com'.freeze

    def customer_store(base_uri = DEFAULT_BASE_URI)
      ServiceMock.new(base_uri)
    end
  end
end
