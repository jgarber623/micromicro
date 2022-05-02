# frozen_string_literal: true

RSpec.describe MicroMicro::Item, '#plain_text_properties' do
  subject(:plain_text_properties) { MicroMicro.parse(markup, base_url).items.first.plain_text_properties }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><a href="http://example.com" class="h-card">Jason Garber</a></body></html>' }

  it 'returns a MicroMicro::Collections::PropertiesCollection' do
    expect(plain_text_properties).to be_a(MicroMicro::Collections::PropertiesCollection)
    expect(plain_text_properties.first.name).to eq('name')
  end
end
