require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ESCopy::Settings' do
  it 'initializes as expected' do
    old_settings = {}
    new_settings = {}

    settings = ESCopy::Settings.new(old_settings, new_settings)
    expect(settings.instance_variable_get('@source_settings')).to eq(old_settings)
    expect(settings.instance_variable_get('@new_settings')).to eq(new_settings)
  end
end
