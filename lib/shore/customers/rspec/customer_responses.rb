module Shore
  module Customers
    module Rspec
      module CustomerResponses # :nodoc:
        extend ActiveSupport::Concern

        # @return Hash
        def customer(attrs = {})
          # TODO@am: validate this Hash with a JSON schema instead
          valid_attributes = %w(id locale tags created_at updated_at identity
                                addresses phones emails urls dates
                                custom_attributes)
          default_customer.merge(attrs).slice(*valid_attributes)
        end

        private

        def customers_resp_body(resp) # rubocop:disable all
          customers = resp['body'].try(:[], 'customers') || []
          {
            'meta' => {
              'current_page' => 1,
              'total_pages' => 1,
              'per_page' => [customers.size, 25].max,
              'total_count' => [customers.size, 1].max
            }.merge(resp['body'].try(:[], 'meta') || {}),
            'customers' => customers.map do |attrs|
              {
                'etag' => "'1cd7a53514da5fe1331bfd599d749f80'",
                'event_id' => SecureRandom.uuid,
                'customer' => customer(attrs)
              }
            end
          }
        end

        def customer_resp_body(attributes, resp)
          attrs = attributes.merge(resp['body'].try(:[], 'customer') || {})
          {
            'customer' => customer(attrs),
            'event_id' => SecureRandom.uuid
          }
        end

        def customer_deleted_body
          {
            'event_id' => SecureRandom.uuid
          }
        end

        def customer_feed_resp_body(oid, customer_id, resp) # rubocop:disable all
          entries = resp['body'].try(:[], 'entries') || [default_feed_entry]
          {
            'entries' => entries.map do |entry|
              {
                'event_id' => SecureRandom.uuid,
                'customer_id' => customer_id,
                'oid' => oid,
                'type' => 'customer.updated',
                'data' => {},
                'created_at' => Time.now.utc.iso8601
              }.merge(entry)
            end
          }
        end

        def default_feed_entry
          {
            'data' => customer.reject do |key|
              %w(id created_at updated_at).include?(key)
            end
          }
        end

        def default_customer # rubocop:disable MethodLength
          # TODO@am: Could we use FactoryGirl for this?
          {
            'id' => SecureRandom.uuid,
            'locale' => nil,
            'tags' => [],
            'created_at' => Time.now.utc.iso8601,
            'updated_at' => Time.now.utc.iso8601,
            'identity' => {
              'gender' => nil,
              'prefix' => nil,
              'first' => nil,
              'middle' => nil,
              'last' => nil,
              'suffix' => nil
            },
            'addresses' => [],
            'phones' => [],
            'emails' => [],
            'urls' => [],
            'dates' => [],
            'custom_attributes' => []
          }
        end
      end
    end
  end
end
