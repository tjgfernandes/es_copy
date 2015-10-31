# require 'simplecov'

# module SimpleCov::Configuration
#   def clean_filters
#     @filters = []
#   end
# end

# SimpleCov.configure do
#   clean_filters
#   load_adapter 'test_frameworks'
# end

# ENV["COVERAGE"] && SimpleCov.start do
#   add_filter "/.rvm/"
# end
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'es_copy'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |_config|
end

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock # or :fakeweb
  # your existing configuration
  config.ignore_hosts 'codeclimate.com'
end

WebMock.disable_net_connect!(:allow => "codeclimate.com")