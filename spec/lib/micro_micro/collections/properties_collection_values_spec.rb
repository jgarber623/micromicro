# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection, '#values' do
  subject(:values) { MicroMicro.parse(markup, base_url).items.first.properties.values }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1><a href="http://example.com" class="p-author h-card">Jason Garber</a></article></body></html>' }

  it 'returns an Array' do
    expect(values).to eq(['Hello, world!', { properties: { name: ['Jason Garber'], url: ['http://example.com/'] }, type: ['h-card'], value: 'Jason Garber' }])
  end
end
