require 'spec_helper'

RSpec.describe CustomerStore::WebhookEndpoints do
  describe CustomerStore::Client do
    before do
      expect(described_class.included_modules)
        .to include(CustomerStore::WebhookEndpoints)
    end

    let(:client) { CustomerStore::Client.new }

    describe '#webhooks_url' do
      it 'should return the webhooks url for the given oid' do
        expect(client.webhooks_url('the-oid'))
          .to eq(customer_store.base_uri + '/v1/the-oid/webhooks')
      end
    end

    describe '#get_webhooks' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_webhooks('')
        end.to raise_error('oid cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_webhooks('the-oid')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/webhooks' do
        expect do
          client.get_webhooks('the-oid')
        end.to call_customer_store.get_webhooks('the-oid')
      end

      it 'should return the status' do
        expect do
          expect(client.get_webhooks('the-oid')['status']).to eq(500)
        end.to call_customer_store.get_webhooks('the-oid', 'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_webhooks('the-oid')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_webhooks('the-oid')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_webhooks('the-oid')['body'])
            .to match(a_hash_including('webhooks' => []))
        end.to call_customer_store.get_webhooks('the-oid')
      end
    end

    describe '#get_webhook' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_webhook('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.get_webhook('the-oid', '')
        end.to raise_error('webhook_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_webhook('the-oid', 'the-id')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/webhooks/the-id' do
        expect do
          client.get_webhook('the-oid', 'the-id')
        end.to call_customer_store.get_webhook('the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.get_webhook('the-oid', 'the-id')['status']).to eq(500)
        end.to call_customer_store.get_webhook('the-oid', 'the-id',
                                               'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_webhook('the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_webhook('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_webhook('the-oid', 'the-id')['body'])
            .to match(a_hash_including(
                        'webhook' => a_hash_including(
                          'id' => 'the-id')))
        end.to call_customer_store.get_webhook('the-oid', 'the-id')
      end
    end

    describe '#update_webhook' do
      it 'should fail if the oid is blank' do
        expect do
          client.update_webhook('', 'the-id', {})
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.update_webhook('the-oid', '', {})
        end.to raise_error('webhook_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.update_webhook('the-oid', 'the-id', {})
        end.to call_customer_store
      end

      it 'should call the customer store PUT /v1/the-oid/webhooks/the-id' do
        expect do
          client.update_webhook('the-oid', 'the-id',
                                'url' => 'http://my.url')
        end.to call_customer_store.update_webhook('the-oid',
                                                  'the-id',
                                                  'url' => 'http://my.url')
      end

      it 'should return the status' do
        expect do
          expect(client.update_webhook('the-oid', 'the-id', {})['status'])
            .to eq(500)
        end.to call_customer_store.update_webhook('the-oid', 'the-id', {},
                                                  'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.update_webhook('the-oid', 'the-id', {})['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.update_webhook('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.update_webhook('the-oid', 'the-id', {})['body'])
            .to match(a_hash_including(
                        'webhook' => a_hash_including('id' => 'the-id'),
                        'event_id' => an_instance_of(String)))
        end.to call_customer_store.update_webhook('the-oid', 'the-id')
      end
    end

    describe '#delete_webhook' do
      it 'should fail if the oid is blank' do
        expect do
          client.delete_webhook('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.delete_webhook('the-oid', '')
        end.to raise_error('webhook_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.delete_webhook('the-oid', 'the-id')
        end.to call_customer_store
      end

      it 'should call the customer store DELETE /v1/the-oid/webhooks/the-id' do
        expect do
          client.delete_webhook('the-oid', 'the-id')
        end.to call_customer_store.delete_webhook('the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.delete_webhook('the-oid', 'the-id')['status'])
            .to eq(500)
        end.to call_customer_store.delete_webhook('the-oid', 'the-id',
                                                  'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.delete_webhook('the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.delete_webhook('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.delete_webhook('the-oid', 'the-id')['body'])
            .to match(a_hash_including('event_id' => an_instance_of(String)))
        end.to call_customer_store.delete_webhook('the-oid', 'the-id')
      end
    end
  end
end
