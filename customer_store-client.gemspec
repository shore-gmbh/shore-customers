# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'customer_store/client/version'

Gem::Specification.new do |spec|
  spec.name = 'customer_store-client'
  spec.version = CustomerStore::Client::VERSION
  spec.authors = ['Austin Moore']
  spec.email = ['am@shore.com']

  spec.summary = 'Customer Store client'
  spec.description = "Client gem to communicate with the Customer \
Store Service (CSS)."
  spec.homepage = 'https://css.shore.com'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail "RubyGems 2.0 or newer is required to protect against public \
gem pushes."
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '>= 0.9.1'
  spec.add_dependency 'activesupport', '>= 3'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
  spec.add_development_dependency 'webmock', '>= 1.21'
  spec.add_development_dependency 'simplecov', '>= 0.10'
  spec.add_development_dependency 'rubocop', '>= 0.32.1'
  spec.add_development_dependency 'overcommit', '>= 0.27.0'
end
