require_relative 'webmock'
require 'customer_store/rspec'

RSpec.configure do |config|
  config.before(:each) do
    ENV['CUSTOMER_STORE_BASE_URI'] = CustomerStore::Rspec::DEFAULT_BASE_URI
    ENV['CUSTOMER_STORE_SECRET'] = nil
    config.include CustomerStore::Rspec
  end
end
