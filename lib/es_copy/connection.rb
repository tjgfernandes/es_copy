require 'addressable/uri'
require 'elasticsearch'

module ESCopy
  # 
  class Connection

    # 
    attr_reader :index, :type, :connection

    # construct the object
    def initialize(source, verbose)
      uri = Addressable::URI.parse(source)
      @index, @type = uri.path[1..-1].split('/')[0..1]
      @verbose = verbose
      @host = Addressable::URI.new(scheme: uri.scheme, host: uri.host, port: uri.port)
      @connection = Elasticsearch::Client.new log: @verbose, host: @host.to_s
    end

    # return a hash for the path components pointing us at the data
    def data_path
      @data_path ||= {
        index: @index,
        type: @type
      }
    end

    # gets the mapping for the index
    def settings
      @connection.indices.get_settings index: @index
    end

    # sets the mapping for the index
    def apply_settings hash
      raise "Index already exists" if exists?
      settings = {
        body: hash,
        index: @index
      }
      @connection.indices.create settings
    end

    # determines if the index exists
    def exists?
      @connection.indices.exists? index: @index
    end

    # copy from me to them
    def copy_to(destination, bulk_size: 100, with: {})
      destination.apply_settings(with)

      scroll_time = '5m'
      search_args = {
        search_type: 'scan',
        scroll: scroll_time,
        size: bulk_size
      }.merge(data_path)
      search = @connection.search search_args
      while search = @connection.scroll(scroll_id: search['_scroll_id'], scroll: scroll_time) and not search['hits']['hits'].empty? do
        items = search['hits']['hits'].inject([]) do |buffer, hit|
          buffer << { index: { _index: destination.index, _type: destination.type, _id: hit['_id'] } }
          buffer << hit['_source']
          buffer
        end
        bulk_result = destination.connection.bulk body: items
        errors = bulk_result.reject{ |i| i['index']['status'].to_s =~ /^20[0-9]/ }
        ap(errors) unless errors.empty?
      end
    end
  end
end