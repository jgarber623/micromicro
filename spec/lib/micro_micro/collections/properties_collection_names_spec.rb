# frozen_string_literal: true

RSpec.describe MicroMicro::Collections::PropertiesCollection, '#names' do
  subject(:names) { MicroMicro.parse(markup, base_url).items.first.properties.names }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<!doctype html><html><body><article class="h-entry"><h1 class="p-name">Hello, world!</h1></article></body></html>' }

  it 'returns an Array' do
    expect(names).to eq(['name'])
  end
end
