# frozen_string_literal: true

RSpec.describe MicroMicro::Item, '#url_properties' do
  subject(:url_properties) { MicroMicro.parse(markup, base_url).items.first.url_properties }

  let(:base_url) { 'http://example.com' }
  let(:markup) { '<html><body><a href="http://example.com" class="h-card">Jason Garber</a></body></html>' }

  it { is_expected.to be_a(MicroMicro::Collections::PropertiesCollection) }
  its('first.name') { is_expected.to eq('url') }
end
