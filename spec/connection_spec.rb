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

  describe 'exists?' do
    it 'should be true' do
      path = 'http://fqdn.domain:1000/index_name/data_type'
      connection = ESCopy::Connection.new(path)
      VCR.use_cassette('index_exists') do
        expect(connection.exists?).to eq(true)
      end
    end

    it 'should be false' do
      path = 'http://fqdn.domain:1000/index_name/data_type'
      connection = ESCopy::Connection.new(path)
      VCR.use_cassette('index_missing') do
        expect(connection.exists?).to eq(false)
      end
    end
  end

  describe 'apply_settings' do
    it 'should fail if index already exists' do
      path = 'http://fqdn.domain:1000/index_name/data_type'
      connection = ESCopy::Connection.new(path)
      VCR.use_cassette('index_exists') do
        expect{connection.apply_settings}.to raise_error(RuntimeError)
      end
    end

    it 'should succeed if the index doesnt exist' do
      path = 'http://fqdn.domain:1000/index_name/data_type'
      connection = ESCopy::Connection.new(path)
      settings = {
        "number_of_shards" => "7",
        "number_of_replicas" => "7"
      }
      VCR.use_cassette('create_index') do
        expect(connection.apply_settings(settings)).to eq({"acknowledged"=>true})
        index_settings = connection.settings
        expect(index_settings['number_of_shards']).to eq(settings['number_of_shards'])
        expect(index_settings['number_of_replicas']).to eq(settings['number_of_replicas'])
      end
    end
  end
end
