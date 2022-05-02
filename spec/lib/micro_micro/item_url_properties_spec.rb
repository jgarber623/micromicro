# frozen_string_literal: true

RSpec.describe MicroMicro::Item, '#url_properties' do
  subject(:url_properties) { MicroMicro.parse(markup, base_url).items.first.url_properties }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><a href="http://example.com" class="h-card">Jason Garber</a></body></html>' }

  it 'returns a MicroMicro::Collections::PropertiesCollection' do
    expect(url_properties).to be_a(MicroMicro::Collections::PropertiesCollection)
    expect(url_properties.first.name).to eq('url')
  end
end
