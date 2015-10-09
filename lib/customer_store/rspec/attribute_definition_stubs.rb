require_relative 'attribute_definition_responses'

module CustomerStore
  module Rspec
    module AttributeDefinitionStubs # :nodoc:
      extend ActiveSupport::Concern
      include RSpec::Matchers
      include RSpec::Expectations::Syntax
      include AttributeDefinitionResponses

      # @return WebMock::RequestStub
      def stub_get_attribute_definitions(oid, resp = {})
        url = "#{base_uri}/v1/#{oid}/attribute_definitions"
        stub_request(:get, url)
          .with(query: hash_including({}))
          .to_return(
            status: attribute_definition_status(resp),
            body: resp['body_json'] ||
              attribute_definitions_resp_body(resp).to_json,
            headers: attribute_definition_headers)
      end

      # @return WebMock::RequestStub
      def stub_get_attribute_definition(oid, id, resp = {})
        url = "#{base_uri}/v1/#{oid}/attribute_definitions/#{id}"
        stub_request(:get, url)
          .with(query: hash_including({}))
          .to_return(
            status: attribute_definition_status(resp),
            body: resp['body_json'] ||
              attribute_definition_resp_body({ 'id' => id }, resp).to_json,
            headers: attribute_definition_headers)
      end

      # @return WebMock::RequestStub
      def stub_create_attribute_definition(oid, attrs = {}, resp = {})
        url = "#{base_uri}/v1/#{oid}/attribute_definitions"
        stub_request(:post, url)
          .with(
            query: hash_including({}),
            body: attribute_definition_update_body(attrs))
          .to_return(
            status: attribute_definition_status(resp),
            body: resp['body_json'] || attribute_definition_resp_body(
              attrs, resp).to_json,
            headers: attribute_definition_headers)
      end

      # @return WebMock::RequestStub
      def stub_update_attribute_definition(oid, id, attrs = {}, resp = {})
        url = "#{base_uri}/v1/#{oid}/attribute_definitions/#{id}"
        stub_request(:put, url)
          .with(
            query: hash_including({}),
            body: attribute_definition_update_body(attrs))
          .to_return(
            status: attribute_definition_status(resp),
            body: resp['body_json'] || attribute_definition_resp_body(
              attrs.merge('id' => id), resp).to_json,
            headers: attribute_definition_headers)
      end

      # @return WebMock::RequestStub
      def stub_delete_attribute_definition(oid, id, resp = {})
        url = "#{base_uri}/v1/#{oid}/attribute_definitions/#{id}"
        stub_request(:delete, url)
          .with(query: hash_including({}))
          .to_return(
            status: attribute_definition_status(resp),
            body: resp['body_json'] ||
              attribute_definition_deleted_body.to_json,
            headers: attribute_definition_headers)
      end

      private

      def attribute_definition_update_body(attrs)
        lambda do |body|
          expect(JSON(body)).to match(hash_including(attrs))
        end
      end

      def attribute_definition_status(resp)
        resp['status'] || 200
      end

      def attribute_definition_headers
        { 'content-type' => 'application/json' }
      end
    end
  end
end
