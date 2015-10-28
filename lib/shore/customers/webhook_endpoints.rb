require 'active_support/all'

module Shore
  module Customers
    module WebhookEndpoints # :nodoc:
      extend ::ActiveSupport::Concern

      def webhooks_url(oid)
        uri = conn.url_prefix.clone
        uri.path = webhooks_path(oid)
        uri.to_s
      end

      def get_webhooks(oid)
        path = webhooks_path(oid)
        format_response(conn.get(path))
      end

      def get_webhook(oid, webhook_id)
        format_response(conn.get(webhook_path(oid, webhook_id)))
      end

      def update_webhook(oid, webhook_id, attributes)
        format_response(conn.put do |req|
                          req.url webhook_path(oid, webhook_id)
                          req.headers['Content-Type'] = 'application/json'
                          req.body = attributes.to_json
                        end)
      end

      def delete_webhook(oid, webhook_id)
        format_response(conn.delete(webhook_path(oid, webhook_id)))
      end

      private

      def webhooks_path(oid)
        fail 'oid cannot be blank' if oid.blank?
        "/v1/#{oid}/webhooks"
      end

      def webhook_path(oid, webhook_id)
        fail 'webhook_id cannot be blank' if webhook_id.blank?
        "#{webhooks_path(oid)}/#{webhook_id}"
      end
    end
  end
end
