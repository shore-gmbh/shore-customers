module CustomerStore
  module Rspec
    module AttributeDefinitionResponses # :nodoc:
      extend ActiveSupport::Concern

      # @return Hash
      def attribute_definition(attrs = {})
        # TODO@am: validate this Hash with a JSON schema instead
        valid_attributes = %w(id name value_type valid_values multivalue
                              created_at updated_at)
        default_attribute_definition.merge(attrs).slice(*valid_attributes)
      end

      private

      def attribute_definitions_resp_body(resp)
        ads = resp['body'].try(:[], 'attribute_definitions') || []
        {
          'attribute_definitions' => ads.map do |attrs|
            {
              'etag' => "'1cd7a53514da5fe1331bfd599d749f80'",
              'event_id' => SecureRandom.uuid,
              'attribute_definition' => attribute_definition(attrs)
            }
          end
        }
      end

      def attribute_definition_resp_body(definition_id, attributes, resp)
        attrs = (resp['body'].try(:[], 'attribute_definition') || attributes)
                .merge('id' => definition_id)
        {
          'attribute_definition' => attribute_definition(attrs),
          'event_id' => SecureRandom.uuid
        }
      end

      def attribute_definition_deleted_body
        {
          'event_id' => SecureRandom.uuid
        }
      end

      def default_attribute_definition
        # TODO@am: Could we use FactoryGirl for this?
        name = "Attribute-#{SecureRandom.uuid}"
        {
          'id' => name.downcase,
          'name' => name,
          'value_type' => 'string',
          'valid_values' => nil,
          'multivalue' => false,
          'created_at' => Time.now.utc.iso8601,
          'updated_at' => Time.now.utc.iso8601
        }
      end
    end
  end
end
