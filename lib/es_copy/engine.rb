module ESCopy
  #
  class Engine
    #
    DEFAULTS = {}

    #
    def self.run!(options)
      options = DEFAULTS.merge(options)

      # create a source
      source = Connection.new(options[:source], options[:verbose])
      return 1 unless source.exists?

      # create a destination
      destination = Connection.new(options[:destination], options[:verbose])
      return 1 if destination.exists?

      # create an appropriate mapping
      settings = Settings.new(source.settings, options[:new_settings])

      # fire off the copy
      source.copy_to(destination, with: settings.transformed, bulk_size: options[:bulk_size])

      return 0
    end
  end
end
