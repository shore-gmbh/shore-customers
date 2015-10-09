require 'spec_helper'

RSpec.describe CustomerStore::AttributeDefinitionEndpoints do
  describe CustomerStore::Client do
    before do
      expect(described_class.included_modules)
        .to include(CustomerStore::AttributeDefinitionEndpoints)
    end

    let(:client) { CustomerStore::Client.new }

    describe '#attribute_definitions_url' do
      it 'should return the attribute_definitions url for the given oid' do
        expect(client.attribute_definitions_url('the-oid'))
          .to eq(customer_store.base_uri + '/v1/the-oid/attribute_definitions')
      end
    end

    describe '#get_attribute_definitions' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_attribute_definitions('')
        end.to raise_error('oid cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_attribute_definitions('the-oid')
        end.to call_customer_store
      end

      it "should call the customer store
GET /v1/the-oid/attribute_definitions" do
        expect do
          client.get_attribute_definitions('the-oid')
        end.to call_customer_store.get_attribute_definitions('the-oid')
      end

      it 'should return the status' do
        expect do
          expect(client.get_attribute_definitions('the-oid')['status'])
            .to eq(500)
        end.to call_customer_store.get_attribute_definitions('the-oid',
                                                             'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_attribute_definitions('the-oid')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_attribute_definitions('the-oid')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_attribute_definitions('the-oid')['body'])
            .to match(a_hash_including('attribute_definitions' => []))
        end.to call_customer_store.get_attribute_definitions('the-oid')
      end
    end

    describe '#get_attribute_definition' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_attribute_definition('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.get_attribute_definition('the-oid', '')
        end.to raise_error('definition_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_attribute_definition('the-oid', 'the-id')
        end.to call_customer_store
      end

      it "should call the customer store \
GET /v1/the-oid/attribute_definitions/the-id" do
        expect do
          client.get_attribute_definition('the-oid', 'the-id')
        end.to call_customer_store.get_attribute_definition('the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.get_attribute_definition(
            'the-oid', 'the-id')['status']).to eq(500)
        end.to call_customer_store.get_attribute_definition('the-oid', 'the-id',
                                                            'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_attribute_definition(
            'the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_attribute_definition('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_attribute_definition('the-oid', 'the-id')['body'])
            .to match(a_hash_including(
                        'attribute_definition' => a_hash_including(
                          'id' => 'the-id')))
        end.to call_customer_store.get_attribute_definition('the-oid', 'the-id')
      end
    end

    describe '#create_attribute_definition' do
      it 'should fail if the oid is blank' do
        expect do
          client.create_attribute_definition('', {})
        end.to raise_error('oid cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.create_attribute_definition('the-oid', {})
        end.to call_customer_store
      end

      it "should call the customer store \
POST /v1/the-oid/attribute_definitions/the-id" do
        expect do
          client.create_attribute_definition('the-oid',
                                             'name' => 'Hair Color')
        end.to call_customer_store.create_attribute_definition(
          'the-oid',
          'name' => 'Hair Color')
      end

      it 'should return the status' do
        expect do
          expect(client.create_attribute_definition(
            'the-oid', {})['status'])
            .to eq(500)
        end.to call_customer_store.create_attribute_definition(
          'the-oid', {},
          'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.create_attribute_definition(
            'the-oid', {})['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.create_attribute_definition('the-oid')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.create_attribute_definition(
            'the-oid', 'name' => 'Hair Color')['body'])
            .to match(a_hash_including(
                        'attribute_definition' => a_hash_including(
                          'name' => 'Hair Color'),
                        'event_id' => an_instance_of(String)))
        end.to call_customer_store.create_attribute_definition(
          'the-oid', 'name' => 'Hair Color')
      end
    end

    describe '#update_attribute_definition' do
      it 'should fail if the oid is blank' do
        expect do
          client.update_attribute_definition('', 'the-id', {})
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.update_attribute_definition('the-oid', '', {})
        end.to raise_error('definition_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.update_attribute_definition('the-oid', 'the-id', {})
        end.to call_customer_store
      end

      it "should call the customer store \
PUT /v1/the-oid/attribute_definitions/the-id" do
        expect do
          client.update_attribute_definition('the-oid', 'the-id',
                                             'name' => 'Hair Color')
        end.to call_customer_store.update_attribute_definition(
          'the-oid',
          'the-id',
          'name' => 'Hair Color')
      end

      it 'should return the status' do
        expect do
          expect(client.update_attribute_definition(
            'the-oid', 'the-id', {})['status'])
            .to eq(500)
        end.to call_customer_store.update_attribute_definition(
          'the-oid', 'the-id', {},
          'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.update_attribute_definition(
            'the-oid', 'the-id', {})['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.update_attribute_definition(
          'the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.update_attribute_definition(
            'the-oid', 'the-id', {})['body'])
            .to match(a_hash_including(
                        'attribute_definition' => a_hash_including(
                          'id' => 'the-id'),
                        'event_id' => an_instance_of(String)))
        end.to call_customer_store.update_attribute_definition(
          'the-oid', 'the-id')
      end
    end

    describe '#delete_attribute_definition' do
      it 'should fail if the oid is blank' do
        expect do
          client.delete_attribute_definition('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.delete_attribute_definition('the-oid', '')
        end.to raise_error('definition_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.delete_attribute_definition('the-oid', 'the-id')
        end.to call_customer_store
      end

      it "should call the customer store \
DELETE /v1/the-oid/attribute_definitions/the-id" do
        expect do
          client.delete_attribute_definition('the-oid', 'the-id')
        end.to call_customer_store.delete_attribute_definition(
          'the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.delete_attribute_definition(
            'the-oid', 'the-id')['status'])
            .to eq(500)
        end.to call_customer_store.delete_attribute_definition(
          'the-oid', 'the-id',
          'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.delete_attribute_definition(
            'the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.delete_attribute_definition(
          'the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.delete_attribute_definition(
            'the-oid', 'the-id')['body'])
            .to match(a_hash_including('event_id' => an_instance_of(String)))
        end.to call_customer_store.delete_attribute_definition(
          'the-oid', 'the-id')
      end
    end
  end
end
