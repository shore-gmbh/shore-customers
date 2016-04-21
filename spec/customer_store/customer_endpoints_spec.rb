require 'spec_helper'

RSpec.describe Shore::Customers::CustomerEndpoints do
  describe Shore::Customers::Client do
    before do
      expect(described_class.included_modules)
        .to include(Shore::Customers::CustomerEndpoints)
    end

    let(:client) { Shore::Customers::Client.new }

    describe '#customers_url' do
      it 'should return the customers url for the given oid' do
        expect(client.customers_url('the-oid'))
          .to eq(customer_store.base_uri + '/v1/the-oid/customers')
      end

      it 'should accept an options hash' do
        expect(client.customers_url('the-oid', 'param' => 'value'))
          .to eq(customer_store.base_uri + '/v1/the-oid/customers?param=value')
      end
    end

    describe '#get_customers' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_customers('')
        end.to raise_error('oid cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_customers('the-oid')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/customers' do
        expect do
          client.get_customers('the-oid')
        end.to call_customer_store.get_customers('the-oid')
      end

      it 'should accept a page parameter' do
        expect do
          client.get_customers('the-oid', 'page' => 2)
        end.to call_customer_store.get_customers('the-oid', 'page' => 2)
      end

      it 'should accept a per_page parameter' do
        expect do
          client.get_customers('the-oid', 'per_page' => 5)
        end.to call_customer_store.get_customers('the-oid', 'per_page' => 5)
      end

      it 'should accept a tags parameter' do
        expect do
          client.get_customers('the-oid', 'tags' => 'all')
        end.to call_customer_store.get_customers('the-oid', 'tags' => 'all')
      end

      it 'should accept combination of parametrs' do
        params = {
          'tags' => 'all',
          'page' => 2,
          'per_page' => 5
        }
        expect do
          client.get_customers('the-oid', params)
        end.to call_customer_store.get_customers('the-oid', params)
      end

      it 'should return the status' do
        expect do
          expect(client.get_customers('the-oid')['status']).to eq(500)
        end.to call_customer_store.get_customers('the-oid', {}, 'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_customers('the-oid')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_customers('the-oid')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_customers('the-oid')['body'])
            .to match(a_hash_including('customers' => []))
        end.to call_customer_store.get_customers('the-oid')
      end
    end

    describe '#get_customer' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_customer('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.get_customer('the-oid', '')
        end.to raise_error('customer_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_customer('the-oid', 'the-id')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/customers/the-id' do
        expect do
          client.get_customer('the-oid', 'the-id')
        end.to call_customer_store.get_customer('the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.get_customer('the-oid', 'the-id')['status']).to eq(500)
        end.to call_customer_store.get_customer('the-oid', 'the-id',
                                                'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_customer('the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_customer('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.get_customer('the-oid', 'the-id')['body'])
            .to match(a_hash_including(
                        'customer' => a_hash_including(
                          'id' => 'the-id')))
        end.to call_customer_store.get_customer('the-oid', 'the-id')
      end
    end

    describe '#get_customer_feed' do
      it 'should fail if the oid is blank' do
        expect do
          client.get_customer_feed('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.get_customer_feed('the-oid', '')
        end.to raise_error('customer_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.get_customer_feed('the-oid', 'the-id')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/customers/the-id' do
        expect do
          client.get_customer_feed('the-oid', 'the-id')
        end.to call_customer_store.get_customer_feed('the-oid', 'the-id')
      end

      it 'should accept an after parameter' do
        expect do
          client.get_customer_feed('the-oid', 'the-id',
                                   'after' => 'the_event_id')
        end.to call_customer_store.get_customer_feed(
          'the-oid', 'the-id',
          'after' => 'the_event_id')
      end

      it 'should return the status' do
        expect do
          expect(client.get_customer_feed('the-oid', 'the-id')['status'])
            .to eq(500)
        end.to call_customer_store.get_customer_feed('the-oid', 'the-id',
                                                     {},
                                                     'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.get_customer_feed('the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.get_customer_feed('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          feed = client.get_customer_feed('the-oid', 'the-id')['body']
          expect(feed['entries']).to be_present
          expect(feed['entries'].first).to match(a_hash_including(
                                                   'customer_id' => 'the-id',
                                                   'oid' => 'the-oid'))
        end.to call_customer_store.get_customer_feed('the-oid', 'the-id')
      end
    end

    describe '#update_customer' do
      it 'should fail if the oid is blank' do
        expect do
          client.update_customer('', 'the-id', {})
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.update_customer('the-oid', '', {})
        end.to raise_error('customer_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.update_customer('the-oid', 'the-id', {})
        end.to call_customer_store
      end

      it 'should call the customer store PUT /v1/the-oid/customers/the-id' do
        expect do
          client.update_customer('the-oid', 'the-id',
                                 'identity' => { 'first' => 'Bob' })
        end.to call_customer_store.update_customer('the-oid',
                                                   'the-id',
                                                   'identity' => {
                                                     'first' => 'Bob' })
      end

      it 'should return the status' do
        expect do
          expect(client.update_customer('the-oid', 'the-id', {})['status'])
            .to eq(500)
        end.to call_customer_store.update_customer('the-oid', 'the-id', {},
                                                   'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.update_customer('the-oid', 'the-id', {})['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.update_customer('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.update_customer('the-oid', 'the-id', {})['body'])
            .to match(a_hash_including(
                        'customer' => a_hash_including('id' => 'the-id'),
                        'event_id' => an_instance_of(String)))
        end.to call_customer_store.update_customer('the-oid', 'the-id')
      end
    end

    describe '#delete_customer' do
      it 'should fail if the oid is blank' do
        expect do
          client.delete_customer('', 'the-id')
        end.to raise_error('oid cannot be blank')
      end

      it 'should fail if the id is blank' do
        expect do
          client.delete_customer('the-oid', '')
        end.to raise_error('customer_id cannot be blank')
      end

      it 'should call the customer store' do
        expect do
          client.delete_customer('the-oid', 'the-id')
        end.to call_customer_store
      end

      it 'should call the customer store GET /v1/the-oid/customers/the-id' do
        expect do
          client.delete_customer('the-oid', 'the-id')
        end.to call_customer_store.delete_customer('the-oid', 'the-id')
      end

      it 'should return the status' do
        expect do
          expect(client.delete_customer('the-oid', 'the-id')['status'])
            .to eq(500)
        end.to call_customer_store.delete_customer('the-oid', 'the-id',
                                                   'status' => 500)
      end

      it 'should return the headers' do
        expect do
          expect(client.delete_customer('the-oid', 'the-id')['headers'])
            .to eq('content-type' => 'application/json')
        end.to call_customer_store.delete_customer('the-oid', 'the-id')
      end

      it 'should return the parsed json body' do
        expect do
          expect(client.delete_customer('the-oid', 'the-id')['body'])
            .to match(a_hash_including('event_id' => an_instance_of(String)))
        end.to call_customer_store.delete_customer('the-oid', 'the-id')
      end
    end
  end
end
