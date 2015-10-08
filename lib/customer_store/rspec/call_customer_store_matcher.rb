require 'securerandom'
require 'webmock'

module CustomerStore
  module Rspec # :nodoc:
    def call_customer_store(base_uri = DEFAULT_BASE_URI)
      CallCustomerStoreMatcher.new(ServiceMock.new(base_uri))
    end

    class CallCustomerStoreMatcher # :nodoc:
      attr_reader :customer_store

      private

      attr_reader :explicit_stubs

      public

      def initialize(customer_store)
        @customer_store = customer_store
        @explicit_stubs = []
      end

      # All of the stub_xyz methods on the ServiceMock are supported
      # (e.g. ServiceMock#stub_get_customers). Let the ServiceMock
      # create the stub and this matcher will verify that the stub
      # was called.
      # @see ServiceMock
      # @see #matches?
      def method_missing(method_sym, *args, &block)
        stub_method = "stub_#{method_sym}".to_sym
        if customer_store.respond_to?(stub_method)
          stub = customer_store.public_send(stub_method, *args)
          explicit_stubs << stub
          return self
        else
          super
        end
      end

      def matches?(actual)
        expect_stubs_called(actual, 1)
      end

      # @private
      def does_not_match?(actual)
        expect_stubs_called(actual, 0)
      end

      # @private
      def supports_block_expectations?
        true
      end

      # def expects_call_stack_jump?
      #   true
      # end

      # @api private
      # @return [String]
      def failure_message
        failed_matcher.failure_message
      end

      # @api private
      # @return [String]
      def failure_message_when_negated
        failed_matcher.failure_message_when_negated
      end

      # @api private
      # @return [String]
      def description
        'call customer store'
      end

      private

      def stub_requests
        if explicit_stubs.present?
          explicit_stubs
        else
          [customer_store.stub_any_request]
        end
      end

      def expect_stubs_called(actual, times)
        fail 'pass block to call_customer_store' unless actual.is_a?(Proc)

        stubs = stub_requests

        actual.call

        @failure = stubs_and_matchers(stubs, times).detect do |stub, matcher|
          !matcher.matches?(stub)
        end

        @failure.nil? ? true : false
      end

      def stubs_and_matchers(stubs, times)
        stubs.map do |stub|
          [stub, WebMock::RequestPatternMatcher.new.times(times)]
        end
      end

      def failed_matcher
        @failure.try(:last)
      end
    end
  end
end
