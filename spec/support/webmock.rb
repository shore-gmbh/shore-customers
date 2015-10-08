require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    # The tests shouldn't be calling anything external. That just slows them
    # down. At most they need a connection to the local database.
    WebMock.disable_net_connect!(allow_localhost: true)
  end
end
