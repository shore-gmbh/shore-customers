require 'active_support/all'

module Shore
  module Customers
    module AttributeDefinitionEndpoints # :nodoc:
      extend ::ActiveSupport::Concern

      def attribute_definitions_url(oid, options = {})
        uri = conn.url_prefix.clone
        uri.path = attribute_definitions_path(oid)
        uri.query = options.to_query if options.present?
        uri.to_s
      end

      def get_attribute_definitions(oid)
        path = attribute_definitions_path(oid)
        format_response(conn.get(path))
      end

      def get_attribute_definition(oid, definition_id)
        format_response(conn.get(attribute_definition_path(oid, definition_id)))
      end

      def create_attribute_definition(oid, attributes)
        format_response(conn.post do |req|
                          req.url attribute_definitions_path(oid)
                          req.headers['Content-Type'] = 'application/json'
                          req.body = attributes.to_json
                        end)
      end

      def update_attribute_definition(oid, definition_id, attributes)
        format_response(conn.put do |req|
                          req.url attribute_definition_path(oid, definition_id)
                          req.headers['Content-Type'] = 'application/json'
                          req.body = attributes.to_json
                        end)
      end

      def delete_attribute_definition(oid, definition_id)
        format_response(conn.delete(attribute_definition_path(
                                      oid, definition_id)))
      end

      private

      def attribute_definitions_path(oid)
        fail 'oid cannot be blank' if oid.blank?
        "/v1/#{oid}/customers/attribute_definitions"
      end

      def attribute_definition_path(oid, definition_id)
        fail 'definition_id cannot be blank' if definition_id.blank?
        "#{attribute_definitions_path(oid)}/#{definition_id}"
      end
    end
  end
end
