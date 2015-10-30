# require 'simplecov'

# module SimpleCov
#   :nodoc
#   class Configuration
#     def clean_filters
#       @filters = []
#     end
#   end
# end

# SimpleCov.configure do
#   clean_filters
#   load_adapter 'test_frameworks'
# end

# ENV['COVERAGE'] && SimpleCov.start do
#   add_filter '/.rvm/'
# end
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')
require 'es_copy'

require 'rspec/expectations'
