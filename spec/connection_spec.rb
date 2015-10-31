require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'awesome_print'

describe 'ESCopy::Connection' do
  it 'should initialize as expected' do
    path = 'http://fqdn.domain:1000/index_name/data_type'
    connection = ESCopy::Connection.new(path)

    expect(connection.instance_variable_get('@index')).to eq('index_name')
    expect(connection.instance_variable_get('@type')).to eq('data_type')
    expect(connection.instance_variable_get('@host').to_s).to eq('http://fqdn.domain:1000')
    expect(connection.instance_variable_get('@verbose')).to eq(false)

    connection = connection.instance_variable_get('@connection')
    expect(connection.class).to be(Elasticsearch::Transport::Client)

    host = connection.instance_variable_get('@transport').instance_variable_get('@options')[:host]
    expect(host).to eq('http://fqdn.domain:1000')

    connection = ESCopy::Connection.new(path, verbose: false)
    expect(connection.instance_variable_get('@verbose')).to eq(false)

    connection = ESCopy::Connection.new(path, verbose: true)
    expect(connection.instance_variable_get('@verbose')).to eq(true)
  end

  it 'should return the settings for the index' do
    path = 'http://fqdn.domain:1000/index_name/data_type'
    connection = ESCopy::Connection.new(path)
    expected = JSON.parse(File.open('fixtures/get_settings_expected.json', 'r').read)
    VCR.use_cassette('get_settings') do
      expect(connection.settings).to eq(expected)
    end
  end
end
