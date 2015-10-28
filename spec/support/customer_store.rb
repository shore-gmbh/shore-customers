require_relative 'webmock'
require 'shore/customers/rspec'

RSpec.configure do |config|
  config.before(:each) do
    ENV['CUSTOMER_STORE_BASE_URI'] = Shore::Customers::Rspec::DEFAULT_BASE_URI
    ENV['CUSTOMER_STORE_SECRET'] = nil
    config.include Shore::Customers::Rspec
  end
end
