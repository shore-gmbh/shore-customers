$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'shore/customers/client'

# Load support files
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on a
    # real object. This is generally recommended, and will default to `true` in
    # RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended.
  config.disable_monkey_patching!

  # Many RSpec users commonly either run the entire suite or an individual file,
  # and it's useful to allow more verbose output when running an individual spec
  # file.
  if config.files_to_run.one?
    # Use the documentation formatter for detailed output, unless a formatter
    # has already been configured (e.g. via a command-line flag).
    config.default_formatter = 'doc'
  end

  # Print the 5 slowest examples and example groups at the end of the spec run,
  # to help surface which specs are running particularly slow.
  config.profile_examples = 5

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce test
  # failures related to randomization by passing the same `--seed` value as the
  # one that triggered the failure.
  Kernel.srand config.seed
end
