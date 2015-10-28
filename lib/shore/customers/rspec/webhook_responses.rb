module Shore
  module Customers
    module Rspec
      module WebhookResponses # :nodoc:
        extend ActiveSupport::Concern

        # @return Hash
        def webhook(attrs = {})
          # TODO@am: validate this Hash with a JSON schema instead
          valid_attributes = %w(id url created_at updated_at)
          default_webhook.merge(attrs).slice(*valid_attributes)
        end

        private

        def webhooks_resp_body(resp)
          webhooks = resp['body'].try(:[], 'webhooks') || []
          {
            'webhooks' => webhooks.map do |attrs|
              {
                'etag' => "'1cd7a53514da5fe1331bfd599d749f80'",
                'event_id' => SecureRandom.uuid,
                'webhook' => webhook(attrs)
              }
            end
          }
        end

        def webhook_resp_body(attributes, resp)
          attrs = attributes.merge(resp['body'].try(:[], 'webhook') || {})
          {
            'webhook' => webhook(attrs),
            'event_id' => SecureRandom.uuid
          }
        end

        def webhook_deleted_body
          {
            'event_id' => SecureRandom.uuid
          }
        end

        def default_webhook
          # TODO@am: Could we use FactoryGirl for this?
          {
            'id' => SecureRandom.uuid,
            'url' => "http://www.css-client.com/incoming/#{SecureRandom.uuid}",
            'created_at' => Time.now.utc.iso8601,
            'updated_at' => Time.now.utc.iso8601
          }
        end
      end
    end
  end
end
