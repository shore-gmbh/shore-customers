require 'active_support/all'

module Shore
  module Customers
    module CustomerEndpoints # :nodoc:
      extend ActiveSupport::Concern

      def customers_url(oid, options = {})
        uri = conn.url_prefix.clone
        uri.path = customers_path(oid)
        uri.query = options.to_query if options.present?
        uri.to_s
      end

      def get_customers(oid, options = {})
        path = customers_path(oid)
        params = options.select do |key, _value|
          %w(page).include?(key)
        end
        conn.get(path, params)
      end

      def get_customer(oid, customer_id)
        conn.get(customer_path(oid, customer_id))
      end

      # @param [Hash] options
      # @option options [String] 'after' Returns only the feed entries created
      #   after the entry with this given event id. Option ignored if
      #   blank or not a known event_id for any of the entries.
      def get_customer_feed(oid, customer_id, options = {})
        conn.get(customer_feed_path(oid, customer_id), options)
      end

      def update_customer(oid, customer_id, attributes)
        conn.put do |req|
          req.url customer_path(oid, customer_id)
          req.body = attributes.to_json
        end
      end

      def delete_customer(oid, customer_id)
        conn.delete(customer_path(oid, customer_id))
      end

      private

      def customers_path(oid)
        fail 'oid cannot be blank' if oid.blank?
        "/v1/#{oid}/customers"
      end

      def customer_path(oid, customer_id)
        fail 'customer_id cannot be blank' if customer_id.blank?
        "#{customers_path(oid)}/#{customer_id}"
      end

      def customer_feed_path(oid, customer_id)
        "#{customer_path(oid, customer_id)}/feed"
      end
    end
  end
end
