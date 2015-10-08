require 'spec_helper'

RSpec.describe CustomerStore::Client do
  it 'has a version number' do
    expect(CustomerStore::Client::VERSION).not_to be nil
  end
end
