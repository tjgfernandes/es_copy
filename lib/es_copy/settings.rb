module ESCopy
  # defines methods to help with settingss
  class Settings
    # create a new settings
    def initialize(source_settings, new_settings)
      @source_settings = source_settings
      @new_settings = new_settings || {}
    end

    # build a new settings from the old one plus the new one
    def transformed
      @source_settings ||= {}
      @source_settings.merge(@new_settings)
    end
  end
end