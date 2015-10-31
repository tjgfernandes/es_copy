require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'ESCopy::Settings' do
  it 'initializes as expected' do
    new_settings = old_settings = { a: :b }

    settings = ESCopy::Settings.new(old_settings, new_settings)
    expect(settings.instance_variable_get('@source_settings')).to eq(old_settings)
    expect(settings.instance_variable_get('@new_settings')).to eq(new_settings)

    settings = ESCopy::Settings.new(old_settings, nil)
    expect(settings.instance_variable_get('@source_settings')).to eq(old_settings)
    expect(settings.instance_variable_get('@new_settings')).to eq({})
  end

  it 'should transform settings as expected' do
    new_settings = { a: :b }
    old_settings = { c: :d }

    settings = ESCopy::Settings.new(old_settings, new_settings)
    expect(settings.transformed).to eq({ a: :b, c: :d })
  end
end
