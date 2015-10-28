require_relative 'webhook_responses'

module Shore
  module Customers
    module Rspec
      module WebhookStubs # :nodoc:
        extend ActiveSupport::Concern
        include RSpec::Matchers
        include RSpec::Expectations::Syntax
        include WebhookResponses

        # @return WebMock::RequestStub
        def stub_get_webhooks(oid, resp = {})
          url = "#{base_uri}/v1/#{oid}/webhooks"
          stub_request(:get, url)
            .with(query: hash_including({}))
            .to_return(
              status: webhook_status(resp),
              body: resp['body_json'] || webhooks_resp_body(resp).to_json,
              headers: webhook_headers)
        end

        # @return WebMock::RequestStub
        def stub_get_webhook(oid, webhook_id, resp = {})
          url = "#{base_uri}/v1/#{oid}/webhooks/#{webhook_id}"
          stub_request(:get, url)
            .with(query: hash_including({}))
            .to_return(
              status: webhook_status(resp),
              body: resp['body_json'] ||
                webhook_resp_body({ 'id' => webhook_id }, resp).to_json,
              headers: webhook_headers)
        end

        # @return WebMock::RequestStub
        def stub_update_webhook(oid, webhook_id, attributes = {}, resp = {})
          url = "#{base_uri}/v1/#{oid}/webhooks/#{webhook_id}"
          stub_request(:put, url)
            .with(
              query: hash_including({}),
              body: webhook_update_body(attributes))
            .to_return(
              status: webhook_status(resp),
              body: resp['body_json'] || webhook_resp_body(
                attributes.merge('id' => webhook_id), resp).to_json,
              headers: webhook_headers)
        end

        # @return WebMock::RequestStub
        def stub_delete_webhook(oid, webhook_id, resp = {})
          url = "#{base_uri}/v1/#{oid}/webhooks/#{webhook_id}"
          stub_request(:delete, url)
            .with(query: hash_including({}))
            .to_return(
              status: webhook_status(resp),
              body: resp['body_json'] || webhook_deleted_body.to_json,
              headers: webhook_headers)
        end

        private

        def webhook_update_body(attributes)
          lambda do |body|
            expect(JSON(body)).to match(hash_including(attributes))
          end
        end

        def webhook_status(resp)
          resp['status'] || 200
        end

        def webhook_headers
          { 'content-type' => 'application/json' }
        end
      end
    end
  end
end
