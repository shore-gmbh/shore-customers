require_relative 'customer_responses'

module Shore
  module Customers
    module Rspec
      module CustomerStubs # :nodoc:
        extend ActiveSupport::Concern
        include RSpec::Matchers
        include RSpec::Expectations::Syntax
        include CustomerResponses

        # @return WebMock::RequestStub
        def stub_get_customers(oid, params = {}, resp = {})
          url = "#{base_uri}/v1/#{oid}/customers"
          stub_request(:get, url)
            .with(query: hash_including(string_params(params)))
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] || customers_resp_body(resp).to_json,
              headers: customer_headers)
        end

        # @return WebMock::RequestStub
        def stub_filter_customers(oid, params = {}, resp = {})
          url = "#{base_uri}/v1/#{oid}/filter/customers"
          stub_request(:post, url)
            .with(
              body: params.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] || customers_resp_body(resp).to_json,
              headers: customer_headers)
        end

        # @return WebMock::RequestStub
        def stub_get_customer(oid, customer_id, resp = {})
          url = "#{base_uri}/v1/#{oid}/customers/#{customer_id}"
          stub_request(:get, url)
            .with(query: hash_including({}))
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] ||
                customer_resp_body({ 'id' => customer_id }, resp).to_json,
              headers: customer_headers)
        end

        # @return WebMock::RequestStub
        def stub_get_customer_feed(oid, customer_id, params = {}, resp = {})
          url = "#{base_uri}/v1/#{oid}/customers/#{customer_id}/feed"
          stub_request(:get, url)
            .with(query: hash_including(string_params(params)))
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] ||
                customer_feed_resp_body(oid, customer_id, resp).to_json,
              headers: customer_headers)
        end

        # @return WebMock::RequestStub
        def stub_update_customer(oid, customer_id, attributes = {}, resp = {})
          url = "#{base_uri}/v1/#{oid}/customers/#{customer_id}"
          stub_request(:put, url)
            .with(
              query: hash_including({}),
              body: customer_update_body(attributes))
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] || customer_resp_body(
                attributes.merge('id' => customer_id), resp).to_json,
              headers: customer_headers)
        end

        # @return WebMock::RequestStub
        def stub_delete_customer(oid, customer_id, resp = {})
          url = "#{base_uri}/v1/#{oid}/customers/#{customer_id}"
          stub_request(:delete, url)
            .with(query: hash_including({}))
            .to_return(
              status: customer_status(resp),
              body: resp['body_json'] || customer_deleted_body.to_json,
              headers: customer_headers)
        end

        private

        def customer_update_body(attributes)
          lambda do |body|
            expect(JSON(body)).to match(hash_including(attributes))
          end
        end

        def customer_status(resp)
          resp['status'] || 200
        end

        def customer_headers
          { 'content-type' => 'application/json' }
        end

        def string_params(params)
          Hash[
            params.map { |key, value| [key.to_s, value.to_s] }
          ]
        end
      end
    end
  end
end
